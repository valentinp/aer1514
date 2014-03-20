function [context, option] = createKinectContext(adjustViewPoint)
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = adjustViewPoint;
    
    mxNiUpdateContext(context, option);

end