function [rgb, depth] = getKinectData(context, option)
    %Captures rgb and depth data from Kinect camera
    mxNiUpdateContext(context, option);
    [rgb, depth] = mxNiImage(context);
end