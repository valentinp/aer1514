function [rgb, depth] = getKinectData(context, varargin)
global rgbObjectMask;

    %Captures rgb and depth data from Kinect camera
    if nargin > 1
        option = varargin{1};
    else
        option.adjust_view_point = true;
    end
    mxNiUpdateContext(context, option);
    [rgb, depth] = mxNiImage(context);
    
    rgb(rgbObjectMask) = 0;
end