% Top level script for setting up paths, setting constants,
% launching GUI, etc.
clear; close all;

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
% Kinect stuff
global context; global option;
global isContextDeleted;
global width; global height;
global rgb; global depth;

% Rover localization
global T_rg;
global T_mk;
global calibStruct;
global isTrackingCalibrated;
global sampleList_k;

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

%% Constants and initializations
% Kinect stuff
isContextDeleted = true;
width = 640;
height = 480;

% Rover Localization
T_rg = NaN;
T_rg_prev = NaN;
T_mk = NaN;

if exist('trackingCalibration.mat', 'file')% == 2
    S = load('trackingCalibration.mat');
    calibStruct = S.calibStruct;
    isTrackingCalibrated = true;
else
    isTrackingCalibrated = false;
end

% Path planning and following
atGoal = true;
v = 0.4;
k1 = 1.5;           % lateral
k2 = 1.5;           % heading
goalThresh = 0.05;  % meters
maxPathLengthMultiple = 1.1;
distTraveled = 0;   % meters

% Teleop mode setting
enableTeleopMode = false;

% Sample found colours
[X, map] = imread('NO.bmp');
noSampleCData = ind2rgb(X,map);

[X,map] = imread('YES.bmp');
foundSampleCData = ind2rgb(X,map);

%% Launch GUI
h = hammerheadGUI;
gui_data = guidata(h);

% Teleop functions
set(h,'KeyPressFcn',@driveOnKeyPress,'KeyReleaseFcn',@brakeOnKeyRelease);

%% Main loop
rto_detectSample = get_param('robulink/Detect Sample Filter','RunTimeObject');
rto_batteryLevel = get_param('robulink/Battery','RunTimeObject');
rto_clearance = get_param('robulink/Ultrasonic Sensor','RunTimeObject');
rto_odometry = get_param('robulink/Wheel Odometry','RunTimeObject');

while ishandle(h)
    [rgb, depth] = getKinectData(context, option);
    set(gui_data.kinectRGB_image,'CData',rgb);
    set(gui_data.kinectDepth_image,'CData',depth);
    
    % Detect the samples
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
    
    % Note: teleop doesn't operate smoothly if all this stuff is going on,
    % so just disable it if we're teleopping since we don't need it anyway
    if ~enableTeleopMode
        
       % Localization etc.
        if isTrackingCalibrated
            [redCentroid, blueCentroid, redVec_k,blueVec_k] = localizeRover(context, rgb, depth, calibStruct);
            if ~isnan(redCentroid)
                displayLocalization(gui_data.kinectRGB, redCentroid, blueCentroid);
            end
            if isfield(terrain,'T_gk');
                
                if ~isnan(redCentroid)
                    T_rg_prev = T_rg;
                    T_rg = localizeInTerrain(redVec_k,blueVec_k, terrain.T_gk);
                end
                % Path following
                if ~atGoal
                    [atGoal, distTraveled] = followPathIteration(T_rg, T_rg_prev, waypoints_g, atGoal, distTraveled);
                    atGoal = atGoal || distTraveled >= maxPathLengthMultiple * pathLength;
                else
                    brake();
                    distTraveled = 0;
                end
            end 
        end
    else
        disp('Warning: In teleop mode. Tracking disabled.');
        atGoal = true;
    end
    
    pause(0.001);
end



