% Top level script for setting up paths, setting constants,
% launching GUI, etc.

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

%% Constants

% Kinect image size
global width;   global height;
width = 640;    height = 480;

% Manual(0) or Auto(1) groud-plane fitting for terrain assessment
terrainAssessmentMode = 1;

% Teleop mode settings
global enableTeleopMode;
enableTeleopMode = true;

%% GUI stuff
[context, option] = createKinectContext(true);
%Note: the w/h values must match the XML parameters read in the createKinectContext
%function above
% Depth image
figure
subplot(1,2,1)
depthIm = imagesc(zeros(height,width,'uint16'));
title('Depth Image')
axis image;

% RGB image
subplot(1,2,2)
rgbIm = imshow(zeros(height,width,3,'uint8'));
title('RGB Image')
axis image;

global samplesTable;
global samplesList;
samplesList = [];
% Samples list
samplesTable = uitable('Position',[100 50 360 75]);

% Create some GUI buttons
btnClose = uicontrol('Style', 'PushButton', ...
                    'String', 'Close', ...
                    'Position', [350 5 120 20], ...
                    'Callback', 'delete(gcbf)');
btnPoints = uicontrol('Style', 'PushButton', ...
                    'String', 'Add Sample(s)', ...
                    'Position', [200 5 120 20], ...
                    'Callback', 'addSample(depth);');
btnClrPoints = uicontrol('Style', 'PushButton', ...
    'String', 'Clear Samples', ...
    'Position', [50 5 120 20], ...
    'Callback', 'samplesList = []; set(samplesTable, ''Data'', samplesList);');

 rto = get_param('robulink/Detect Sample Filter','RunTimeObject');
while (ishandle(depthIm))
    [rgb, depth] = getKinectData(context, option);
    set(rgbIm,'CData',rgb)
    set(depthIm,'CData',depth)
    overSample = rto.OutputPort(1).Data;
    disp(overSample);
    pause(0.03);
end
mxNiDeleteContext(context);





