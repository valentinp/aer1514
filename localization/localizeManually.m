function [redCentroid, blueCentroid, redVec_k, blueVec_k] = localizeManually(context, rgb, depth)
    global height;
    global width;

    f = figure();
    imgHandle = imshow(zeros(height,width,3,'uint8'));
    displayKinectRGB(rgb,imgHandle); 

    disp('Select centroid of BLUE ball');  
    [x_blue,y_blue] = ginput(1);
    disp('Select centroid of RED ball');  
    [x_red,y_red] = ginput(1);
    
    kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;  % height x width x 3 (meters)
    
    redVec_k = reshape(kinectPoints_k(round(y_red), round(x_red), :), [3 1]);
    blueVec_k = reshape(kinectPoints_k(round(y_blue), round(x_blue), :), [3 1]);
    
    redCentroid = [x_red; y_red];
    blueCentroid = [x_blue; y_blue];

    close (f);
end