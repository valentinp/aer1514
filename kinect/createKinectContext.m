function [context, option] = createKinectContext()
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = false;
    
    mxNiUpdateContext(context, option);

end