% Get RGB and DEPTH image via Kinect
addpath('./Mex');
%% Create context with xml file
context = mxNiCreateContext('Config/SamplesConfig_HighRes.xml');

%% Initialise FIGURE
width = 1280; 
height = 1024;
% depth image
figure(1);
h1 = imagesc(zeros(height,width,'uint16'));
% rgb image
figure(2);
h2 = imagesc(zeros(height,width,3,'uint8'));

%align Depth onto RGB
option.adjust_view_point = true;
% Acquire RGB and Depth image
mxNiUpdateContext(context, option);
[rgb, depth] = mxNiImage(context);
% Update figure 
set(h1,'CData',flipdim(depth,2)); 
set(h2,'CData',flipdim(rgb,2)); 
drawnow;

%% Delete the context object
mxNiDeleteContext(context);