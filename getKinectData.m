function [rgb, depth] = getKinectData
% Captures rgb and depth data from Kinect camera

    addpath('./kinect/Mex');
    
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = true;
    % Acquire RGB and Depth image
    mxNiUpdateContext(context, option);
    [rgb, depth] = mxNiImage(context);
    
    % Delete the context object
    mxNiDeleteContext(context);
end