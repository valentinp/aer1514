% Get required images for kinect calibration toolkit
addpath('kinect');
addpath('kinect/Mex');

clear all; close all;

% Parameters
numImages = 20;
dataDir = 'kinect_calib_data\';
dataSet = 'our_kinect';
height = 480;
width = 640;

% Do stuff
dataPath = [dataDir,dataSet,'\'];
if ~exist(dataPath, 'dir')
    mkdir(dataPath);
end

[context, option] = createKinectContext(true);

hRGB = figure(1); hRGB = imagesc(zeros(height,width,3,'uint8'));
hDepth = figure(2); hDepth = imagesc(zeros(height,width,'uint16'));

for i = 0:numImages-1
    disp('Position the calibration target and press a key to capture');
    pause();
    
    [rgb,depth] = getKinectData(context, option);
    
    displayKinectRGB(rgb, hRGB);
    displayKinectDepth(depth, hDepth);
    
    imwrite(rgb,[dataPath,num2str(i,'%04d'),'-c1.jpg'],'jpg');
    imwrite(depth,[dataPath,num2str(i,'%04d'),'-d.pgm'],'pgm');    
end

mxNiDeleteContext(context);
clear all; close all;