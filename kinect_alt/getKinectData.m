function [rgb, depth] = getKinectData(context, varargin)
    %Captures rgb and depth data from Kinect camera
    if nargin > 1
        option = varargin{1};
    else
        option.adjust_view_point = true;
    end
    rgb=mxNiPhoto(context); rgb=permute(rgb,[3 2 1]);
    depth=mxNiDepth(context); depth=permute(depth,[2 1]);
    mxNiUpdateContext(context);
 end