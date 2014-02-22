function [rgb, depth] = getKinectData(context)
% Captures rgb and depth data from Kinect camera

    addpath('./kinect/Mex');
    
    [rgb, depth] = mxNiImage(context);
end