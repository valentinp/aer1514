function [context, option] = createKinectContext()
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig_HighRes.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = true;
    
    mxNiUpdateContext(context, option);

end