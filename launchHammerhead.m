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

% Sample localization
global samplesList; global samplesTable;

% Path planning and following
global xGoal_g; global yGoal_g;
global waypoints_g;

% Terrain
global terrain;

% Teleop mode settings
global enableTeleopMode;

%% Launch GUI
h = hammerheadGUI;
gui_handles = guihandles(h);

% Teleop functions
set(h,'KeyPressFcn',@driveOnKeyPress,'KeyReleaseFcn',@brakeOnKeyRelease);

% Initialize kinect images in gui
kinectRGB_CData = imshow(zeros(height,width,3,'uint8'), 'Parent', gui_handles.kinectRGB);
kinectDepth_CData = imagesc(zeros(height,width,'uint16'), 'Parent', gui_handles.kinectDepth);
kinectOverlays_CData = imshow(zeros(height,width,3,'uint8'), 'Parent', gui_handles.kinectOverlays);

% Set up samples list
samplesTable = gui_handles.table_samples;
samplesList = [];

% Main loop
% rto = get_param('robulink/Detect Sample Filter','RunTimeObject');
while ishandle(h)
    [rgb, depth] = getKinectData(context, option);
    set(kinectRGB_CData,'CData',rgb);
    set(kinectDepth_CData,'CData',depth);
    pause(0.01);
end

%% Old GUI stuff
% [context, option] = createKinectContext();
%Note: the w/h values must match the XML parameters read in the createKinectContext
%function above

% GUI main figure
% gui_handle = figure;
% set(gui_handle, 'Units','Normalized','Position',[0.01 0.07 0.7 0.85]);
% 
% % Teleop functions
% set(gui_handle,'KeyPressFcn',@driveOnKeyPress,'KeyReleaseFcn',@brakeOnKeyRelease);
% 
% % Depth image
% subplot(1,2,1)
% depthIm = imagesc(zeros(height,width,'uint16'));
% title('Depth Image')
% axis image;
% 
% % RGB image
% subplot(1,2,2)
% rgbIm = imshow(zeros(height,width,3,'uint8'));
% title('RGB Image')
% axis image;
% 
% global samplesTable;
% global samplesList;
% samplesList = [];
% % Samples list
% samplesTable = uitable('Position',[100 50 360 75]);
% 
% % Create some GUI buttons
% btnClose = uicontrol('Style', 'PushButton', ...
%                     'String', 'Close', ...
%                     'Units', 'Normalized', ...
%                     'Position', [350 5 120 20], ...
%                     'Callback', 'delete(gcbf)');
% btnPoints = uicontrol('Style', 'PushButton', ...
%                     'String', 'Add Sample(s)', ...
%                     'Units', 'Normalized', ...
%                     'Position', [200 5 120 20], ...
%                     'Callback', 'addSample(depth);');
% btnClrPoints = uicontrol('Style', 'PushButton', ...
%                     'String', 'Clear Samples', ...
%                     'Units', 'Normalized', ...
%                     'Position', [50 5 120 20], ...
%                     'Callback', 'samplesList = []; set(samplesTable, ''Data'', samplesList);');
% btnTerrainAssessment = uicontrol('Style', 'PushButton', ...
%                     'String', 'Assess Terrain', ...
%                     'Position', [50 30 120 20], ...
%                     'Callback', 'terrainAssessment_callback');                
% btnNavGoal = uicontrol('Style', 'PushButton', ...
%                     'String', 'Select Nav Goal', ...
%                     'Units', 'Normalized', ...
%                     'Position', [200 30 120 20], ...
%                     'Callback', 'addSample(depth);');
% 
% % Main loop
% rto = get_param('robulink/Detect Sample Filter','RunTimeObject');
% while (ishandle(depthIm))
%     [rgb, depth] = getKinectData(context, option);
%     set(rgbIm,'CData',rgb)
%     set(depthIm,'CData',depth)
%     overSample = rto.OutputPort(1).Data;
%     disp(overSample);
%     pause(0.03);
% end
% 
% mxNiDeleteContext(context);





