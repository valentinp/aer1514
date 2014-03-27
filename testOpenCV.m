addpath('kinect');
addpath('kinect/Mex');
addpath('kinect/Config');
addpath('C:\code\mexopencv-master');

[context,option] = createKinectContext();




[rgb,depth] = getKinectData(context,option);
f = figure();
im_handle = imshow(rgb);
 
disp('Select top left and bottom right corners of the blue ball');  
[x_blue,y_blue] = ginput(2);
disp('Select top left and bottom right corners of the red ball');  
[x_red,y_red] = ginput(2);

 
 blue_pixels = rgb(round(y_blue(1)):round(y_blue(2)), round(x_blue(1)):round(x_blue(2)), :);
 red_pixels = rgb(round(y_red(1)):round(y_red(2)), round(x_red(1)):round(x_red(2)),:);

 detector = cv.FeatureDetector('SURF');
 extractor = cv.DescriptorExtractor('SURF');
 matcher = cv.DescriptorMatcher('BruteForce');
 


im_blue = cv.cvtColor(blue_pixels,'RGB2GRAY');
im_red = cv.cvtColor(red_pixels,'RGB2GRAY');


[keypoints_blue, descriptors_blue] = cv.SURF(im_blue, 'HessianThreshold', 50, 'NOctaves', 10);
[keypoints_red, descriptors_red] = cv.SURF(im_red,'HessianThreshold', 50, 'NOctaves', 10);

% keypoints_blue = detector.detect(im_blue);
% keypoints_red = detector.detect(im_red);
% 
% 
% descriptors_blue = extractor.compute(im_blue,keypoints_blue);
% descriptors_red = extractor.compute(im_red,keypoints_red);

if ~(isempty(descriptors_blue) || isempty(descriptors_red))
    


 

    while ishandle(im_handle)
    %im = imread(fullfile(mexopencv.root(),'test','img001.jpg'))
    [rgb,depth] = getKinectData(context,option);
    im = cv.cvtColor(rgb,'RGB2GRAY');
    
%     keypoints = detector.detect(im);
%     descriptors = extractor.compute(im,keypoints);

[keypoints, descriptors] = cv.SURF(im,'HessianThreshold', 50, 'NOctaves', 16);

    matches_red = matcher.match(descriptors_red, descriptors);
    matches_blue = matcher.match(descriptors_blue, descriptors);

    kpt_red_idx = zeros(1, length(matches_red));
    for i =  1:length(matches_red)
        kpt_red_idx(i) = matches_red(i).trainIdx + 1;
    end
    
    kpt_blue_idx = zeros(1, length(matches_blue));
    for i =  1:length(matches_blue)
        kpt_blue_idx(i) = matches_blue(i).trainIdx + 1;
    end
    
    disp(length(matches_red));
    disp(length(matches_blue));
    kpt_idx = [kpt_red_idx kpt_blue_idx];
    im_keypoints = cv.drawKeypoints(im,keypoints(kpt_idx));
    set(im_handle, 'CData', im_keypoints);
    %imshow(im_keypoints);
    pause(0.03);
    end

end
mxNiDeleteContext(context);