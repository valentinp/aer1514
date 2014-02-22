function context = createKinectContext(adjustViewPoint)
% Create context for Kinect image capture

    addpath('./kinect/Mex');
    
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = adjustViewPoint;
    
    mxNiUpdateContext(context, option);

end