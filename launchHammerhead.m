% Top level script for setting up paths, setting constants,
% launching GUI, etc.

%% Open the model
open('./simulink/robulink.slx');

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
isContextDeleted = true;

global width;   global height;
width = 640;    height = 480;

global rgb; global depth;

% Rover localization
global T_rg;
global trackingStruct;
global isTrackingCalibrated;


% Path planning and following
global waypoints_g;

% Terrain
global terrain;

% Teleop mode settings
global enableTeleopMode;

%% Launch GUI
h = hammerheadGUI;
gui_data = guidata(h);

% Teleop functions
set(h,'KeyPressFcn',@driveOnKeyPress,'KeyReleaseFcn',@brakeOnKeyRelease);

% Initialize some stuff
T_rg = NaN;
rto = get_param('robulink/Detect Sample Filter','RunTimeObject');

% Main loop
while ishandle(h)
    [rgb, depth] = getKinectData(context, option);
    set(gui_data.kinectRGB_image,'CData',rgb);
    set(gui_data.kinectDepth_image,'CData',depth);
    
    if isTrackingCalibrated
        displayLocalization(gui_data.kinectRGB, rgb, trackingStruct);
        
        if exist('terrain.T_gk', 'var')
            T_rg = localizeRover(context, rgb, depth,trackingStruct, terrain.T_gk);
        end
    end
    
    pause(0.02);
end





