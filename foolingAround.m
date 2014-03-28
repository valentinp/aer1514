addpath('kinect');
addpath('kinect/Mex');
addpath('kinect/Config');

[context,option] = createKinectContextHighRes();

[rgb,depth] = getKinectData(context,option);
f = figure();
im_handle = imshow(rgb);
 


 

    while ishandle(im_handle)
    %im = imread(fullfile(mexopencv.root(),'test','img001.jpg'))
    [rgb,depth] = getKinectData(context,option);
    %im = cv.cvtColor(rgb,'RGB2GRAY');
    
    set(im_handle, 'CData', rgb);
    mxNiUpdateContext(context);
    %imshow(im_keypoints);
    drawnow;
    pause(0.001);
    end


mxNiDeleteContext(context);
