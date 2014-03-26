function [rgb, depth] = getKinectData(context, varargin)
    %Captures rgb and depth data from Kinect camera
    if nargin > 1
        option = varargin{1};
    else
        option.adjust_view_point = true;
    end
    [rgb, depth] = mxNiImage(context);
     mxNiUpdateContext(context, option);
end