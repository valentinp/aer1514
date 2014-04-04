% Top level script for setting up paths, setting constants,
% launching GUI, etc.
% clear all; close all;

%% Open the model
% Don't do this. Running the model on the robot after opening the GUI screws up the GUI.
% open('robulink.slx');

%% Paths
addpath('gui');
KINECT_FOLDER = 'kinect';
addpath(KINECT_FOLDER);
addpath([KINECT_FOLDER '/Mex']);
addpath([KINECT_FOLDER '/Config']);

addpath('localization');
addpath('path_following');
addpath('rover_functions');
addpath('terrain_assessment');
addpath('utils');

%% Global Variables
% Safety
global vAbsMax;
global omegaAbsMax;

% Kinect stuff
global context; global option;
global isContextDeleted;
global width; global height;
global rgb; global depth;
global U; global V;
global maxDepth;

% Rover localization
global T_rg;
global framePoints_k;
global calibStruct;
global isTrackingCalibrated;
global sampleList_k;
global lastPixVec;
global rgbObjectMask;
global localizeManuallyThisIter;

% Path planning and following
global waypoints_g; global pathLength;
global atGoal;
global v; global k1; global k2;
global goalThresh;
global maxPathLengthMultiple;

% Terrain
global terrain;

% Teleop mode settings
global enableTeleopMode;
global v_teleop; global omega_teleop;

%% Constants and initializations
% Safety
vAbsMax = 0.6;
omegaAbsMax = 4;

% Kinect stuff
isContextDeleted = true;
width = 640;
height = 480;
[U,V] = meshgrid(1:width, 1:height);
maxDepth = 10000; % mm
lostKinectTrackingCount = 0;
lostKinectTracking  = false;
T_1s = NaN;
savedMapImages = false;


% Rover Localization
T_rg = NaN;
T_rg_prev = NaN;
T_rg_last_kinect = NaN;
T_rg_history = zeros(4,4);
lostKinectCount = 0;
rgbObjectMask = repmat(false(height,width), [1,1,3]);
localizeManuallyThisIter = false;

%Rolling average filter for the Transformation
FILTER_SIZE = 3;
T_rg_filter = zeros(4,4,FILTER_SIZE);

T_rg_kinect_flag = false;
T_rg_start_flag = false;
T_mk = NaN;
lastPixVec = NaN;

if exist('trackingCalibration.mat', 'file')% == 2
    S = load('trackingCalibration.mat');
    calibStruct = S.calibStruct;
    isTrackingCalibrated = true;
else
    isTrackingCalibrated = false;
end


% Path planning and following
atGoal = true;
v = 0.5;
k1 = 0.5;           % lateral
k2 = 2;           % heading


goalThresh = 0.3;  % meters
maxPathLengthMultiple = 10;
distTraveled = 0;   % meters

% Teleop mode setting
enableTeleopMode = false;
v_teleop = 0.5;
omega_teleop = 4;

% Sample found colours
[X, map] = imread('NO.bmp');
noSampleCData = ind2rgb(X,map);

[X,map] = imread('YES.bmp');
foundSampleCData = ind2rgb(X,map);

%% Launch GUI
h = hammerheadGUI;
gui_data = guidata(h);

% Keyboard control
set(h,'KeyPressFcn',@KeyPressFcn,'KeyReleaseFcn',@KeyReleaseFcn);

%% Main loop
rto_detectSample = get_param('robulink/Detect Sample Filter','RunTimeObject');
rto_lightSensor = get_param('robulink/Light Sensor','RunTimeObject');
rto_batteryLevel = get_param('robulink/Battery','RunTimeObject');
rto_clearance = get_param('robulink/Ultrasonic Sensor','RunTimeObject');
rto_odometry = get_param('robulink/Wheel Odometry','RunTimeObject');
rto_odometryState = get_param('robulink/Display State','RunTimeObject');

%Reset the co-ordinate frame
resetFlag = str2num(get_param('robulink/resetFlag','Value'));
set_param('robulink/resetFlag','Value', num2str(~resetFlag));

%Debug
dstate_list = [];

while ishandle(h)
% tic
    % Kinect data streams
    [rgb, depth] = getKinectData(context, option);
    
    if isfield(terrain, 'T_kg')
        [depth,~] = fillMissingDepthWithGroundPlane(context, depth, U, V, terrain.m, terrain.n, terrain.p);
        if ~savedMapImages
            mappingData.rgb = rgb;
            mappingData.depth = depth;
            mappingData.realWorldCoords_k = mxNiConvertProjectiveToRealWorld(context, depth)/1000;
            save('mappingData.mat','mappingData');
            
            savedMapImages = true;
        end
    end

    set(gui_data.kinectRGB_image,'CData',rgb);
    set(gui_data.kinectDepth_image,'CData',depth);
    


    % Detect the samples
    if ~isempty(rto_lightSensor)
         set(gui_data.txt_sampleDetection, 'String', num2str(rto_lightSensor.OutputPort(1).Data));
    else
         set(gui_data.txt_sampleDetection, 'String', 'n/a');
    end
    
    if ~isempty(rto_detectSample) && rto_detectSample.OutputPort(1).Data
        set(gui_data.overSample_image, 'CData', foundSampleCData);
        overSample = true;
    else
        overSample = false;
         set(gui_data.overSample_image, 'CData', noSampleCData);
    end
    
    
    %Health and safety
    if ~isempty(rto_batteryLevel)
        set(gui_data.txt_batteryLevel, 'String', [num2str(rto_batteryLevel.OutputPort(1).Data) ' mV']);
    end
    
    if ~isempty(rto_odometry)
        set(gui_data.txt_velocity, 'String', [num2str(norm([rto_odometry.OutputPort(1).Data, rto_odometry.OutputPort(2).Data]),2) ' m/s']);
        set(gui_data.txt_omega, 'String', [num2str(rto_odometry.OutputPort(3).Data,2) ' deg/s']);
    end
    
    if ~isempty(rto_clearance)
        set(gui_data.txt_clearance, 'String', num2str(rto_clearance.OutputPort(1).Data));
    end
    
    % Note: teleop doesn't operate smoothly if all this stuff is going on,
    % so just disable it if we're teleopping since we don't need it anyway
    if true%~enableTeleopMode
        
       % Localization etc.
        if isTrackingCalibrated

            if localizeManuallyThisIter
                [redCentroid, blueCentroid, redVec_k, blueVec_k] = localizeManually(context, rgb, depth);
                localizeManuallyThisIter = false;
            else
                [redCentroid, blueCentroid, redVec_k,blueVec_k] = localizeRover(context, rgb, depth, calibStruct, lastPixVec);
            end
                
            if ~isnan(redCentroid)
               displayLocalization(gui_data.kinectRGB, redCentroid, blueCentroid);
               lastPixVec = redCentroid - blueCentroid;
            end

            if isfield(terrain, 'T_gk')

                    T_rg_prev = T_rg;
                    if ~isnan(redCentroid(1)) 
                        T_rg = localizeInTerrain(redVec_k,blueVec_k, terrain.T_gk);
                        T_rg_last_kinect = T_rg; %Used for keeping track of the last T_rg that came from the kinect
                        lostKinectCount = 0;
                        resetFlag = str2num(get_param('robulink/resetFlag','Value'));
                        set_param('robulink/resetFlag','Value', num2str(~resetFlag));
                        
                    elseif ~isempty(rto_odometryState)
                        dx = rto_odometryState.OutputPort(1).Data;
                        dy = rto_odometryState.OutputPort(2).Data;
                        dtheta = rto_odometryState.OutputPort(3).Data;
                        dstate = [dx dy dtheta]';
                        if sum(dstate) > 0
                            disp(dstate);
                        end
                        lostKinectCount =lostKinectCount+1;
                        %Do not consider the first iteration where kinect
                        %data is lost
                        if lostKinectCount > 3
                            T_rg = localizeWithWheelOdom(dx,dy,dtheta, T_rg_last_kinect);
                        end
                        
                    else
                        T_rg = NaN;
                    end
                 %T_rg_history(:,:,end+1) = inv(T_rg);     
                % Path following
                if ~atGoal && ~overSample
                    

                    
                    set_param('robulink/resetFlag','Value', '0');
                    [atGoal, distTraveled] = followPathIteration(T_rg, T_rg_prev, waypoints_g, atGoal, distTraveled);
                    disp(['Distance Traveled: ' num2str(distTraveled) ' / ' num2str(pathLength)]);
                    %atGoal = atGoal || distTraveled >= maxPathLengthMultiple * pathLength;
                    rovPos = T_rg \ [0 0 0 1]';

                    if atGoal
                        distTraveled
                        disp('SUCCESS: Path completed.');
                        brake();
                    end
                elseif overSample
                     brake();
                     atGoal = true;
                     disp('SUCCESS: Path completed.');
                     disp('FOUND SAMPLE!');
                else
                    distTraveled = 0;
                end
                
            end 
        end
    else
        atGoal = true;
    end
    
    drawnow;
    pause(0.001);
end