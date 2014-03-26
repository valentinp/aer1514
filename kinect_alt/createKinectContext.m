function [context, option] = createKinectContext()
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = true;
    
    %mxNiUpdateContext(context);
    
end