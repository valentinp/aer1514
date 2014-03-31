% Top level script for setting up paths, setting constants,
% launching GUI, etc.
clear all; close all;

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
global T_mk;
global calibStruct;
global isTrackingCalibrated;
global sampleList_k;
global lastPixVec;

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


% Rover Localization
T_rg = NaN;
T_rg_prev = NaN;
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
% k1 = 1.5;           % lateral
% k2 = 1.5;           % heading
k1 = 2; %lateral
k2 = 1.2; %heading

goalThresh = 0.3;  % meters
maxPathLengthMultiple = 1.02;
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
while ishandle(h)
    mxNiUpdateContext(context, option);
    [rgb, depth] = getKinectData(context, option);

    if isfield(terrain, 'T_kg')
        [depth,~] = fillMissingDepthWithGroundPlane(context, depth, U, V, terrain.m, terrain.n, terrain.p);
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
    else
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
    if ~enableTeleopMode
        
       % Localization etc.
        if isTrackingCalibrated
            [redCentroid, blueCentroid, redVec_k,blueVec_k] = localizeRover(context, rgb, depth, calibStruct, lastPixVec);
            if ~isnan(redCentroid)
                displayLocalization(gui_data.kinectRGB, redCentroid, blueCentroid);
                lastPixVec = redCentroid - blueCentroid;
            end
            
            if isfield(terrain, 'T_gk')
                
                T_rg_prev = T_rg;
                if ~isnan(redCentroid) 
                    if lostKinectTracking && lostKinectTrackingCount < 3 %Ensure that we have tracking for at least 10 frames before reverting back to Kinect tracking
                        lostKinectTrackingCount = lostKinectTrackingCount + 1;
                        T_2s = localizeWithWheelOdom(rto_odometryState.OutputPort(1).Data,rto_odometryState.OutputPort(2).Data,rto_odometryState.OutputPort(3).Data);
                        T_21 = T_2s*inv(T_1s);
                        T_rg = T_21*T_rg_lost;
                        disp(['Regaining Kinect tracking. Frame ' num2str(lostKinectTrackingCount) '/3']);    
                    else
                        T_rg = localizeInTerrain(redVec_k,blueVec_k, terrain.T_gk);
                        lostKinectTracking = false;
                        lostKinectTrackingCount = 0;
                        T_1s = NaN;
                    end
                elseif isnan(redCentroid) && ~isempty(rto_odometryState)
                    lostKinectTracking = true;
                    lostKinectTrackingCount = 0;
                    if isnan(T_1s)
                        T_1s = localizeWithWheelOdom(rto_odometryState.OutputPort(1).Data,rto_odometryState.OutputPort(2).Data,rto_odometryState.OutputPort(3).Data);
                        T_rg_lost = T_rg;
                        disp('Lost Kinect tracking.');
                    else
                         T_2s = localizeWithWheelOdom(rto_odometryState.OutputPort(1).Data,rto_odometryState.OutputPort(2).Data,rto_odometryState.OutputPort(3).Data);
                         T_21 = T_2s*inv(T_1s);
                         T_rg = T_21*T_rg_lost;
                    end
                end
                        
                                
                % Path following
                if ~atGoal
                    set_param('robulink/resetFlag','Value', '0');
                    [atGoal, distTraveled] = followPathIteration(T_rg, T_rg_prev, waypoints_g, atGoal, distTraveled);
                    disp(['Distance Traveled: ' num2str(distTraveled)]);
                    atGoal = atGoal || distTraveled >= maxPathLengthMultiple * pathLength;
                else
                    brake();
                    distTraveled = 0;
                    set_param('robulink/resetFlag','Value', '1');

                end
            end 
        end
    else
%         disp('Warning: In teleop mode. Tracking disabled.');
        atGoal = true;
    end
    
    drawnow;
    pause(0.001);
end