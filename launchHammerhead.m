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

%% GUI stuff
