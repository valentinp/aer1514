% Top level script for setting up paths, setting constants,
% launching GUI, etc.

%% Open the model
% Don't do this. Running the model on the robot after opening the GUI screws up the GUI.
% open('./simulink/robulink.slx');

%% Paths
addpath('gui');
addpath('kinect');
addpath('kinect/Mex');
addpath('kinect/Config');
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
global T_rg; global T_rg_start;
global trackingStruct;
global isTrackingCalibrated;

% Path planning and following
global waypoints_g; global startpoint_g; global pathLength;
global atGoal;
global v; global k1; global k2;
global goalThresh; global maxPathLengthMultiple;

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
T_rg = NaN; T_rg_initial = NaN;
T_rg_prev = NaN;
isTrackingCalibrated = false;

% Path planning and following
atGoal = true;
v = 0.4;
k1 = 1.5;           % lateral
k2 = 1.5;           % heading
goalThresh = 0.05;  % meters
maxPathLengthMultiple = 1.1;
distTraveled = 0;   % meters

% Teleop mode setting
enableTeleopMode = true;

% Sample found colours
noSampleColour(1,1,:) = [0,0,0];
foundSampleColour(1,1,:) = [0,1,0];

noSampleCData = repmat(noSampleColour, [10,10,1]);
foundSampleCData = repmat(foundSampleColour, [10,10,1]);

%% Launch GUI
h = hammerheadGUI;
gui_data = guidata(h);

% Teleop functions
set(h,'KeyPressFcn',@driveOnKeyPress,'KeyReleaseFcn',@brakeOnKeyRelease);

%% Main loop
rto_detectSample = get_param('robulink/Detect Sample Filter','RunTimeObject');
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
    
    % Localization etc.
    if isTrackingCalibrated
        displayLocalization(gui_data.kinectRGB, rgb, trackingStruct);
        
        if isfield(terrain,'T_gk');
            T_rg_prev = T_rg;
            T_rg = localizeRover(context, rgb, depth,trackingStruct, terrain.T_gk);
            
            % Save the initial rover position
            if isnan(T_rg_initial)
                T_rg_initial = T_rg;
            else
                % This will happen on the next iteration after T_rg_initial
                % stops being NaN
                startpoint_g = homo2cart(T_rg_initial \ [0;0;0;1]);
            end
            
            % Path following
            if enableTeleopMode && ~atGoal
                disp('Warning: In teleop mode. Path following disabled.');
                atGoal = true;
            else
                if ~atGoal
                    [atGoal, distTraveled] = followPathIteration(T_rg, T_rg_prev, waypoints_g, atGoal, distTraveled);
                    atGoal = atGoal || distTraveled >= maxPathLengthMultiple * pathLength;
                else
                    brake();
                    distTraveled = 0;
                end
            end
        end        
    end
    
    pause(0.01);
end





