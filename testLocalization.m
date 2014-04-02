addpath('gui');
addpath('kinect');
addpath('kinect/Mex');
addpath('kinect/Config');
addpath('localization');
addpath('path_following');
addpath('rover_functions');
addpath('terrain_assessment');
addpath('utils');

% Constants
global height;
global width;
 height = 480;               % pixels
 width = 640;                % pixels

%Extract rgb and depth image
close all;
prevPixVec = NaN;
 
%Set up GUI
fig = figure(1);
h = imagesc(zeros(height,width,3,'uint8'));
axesHandles = get(fig, 'Children');

%Intialize
scatterPointsR = [];
scatterPointsB = [];


[context,option] = createKinectContext();

[rgb,depth] = getKinectData(context);
G = fspecial('gaussian',[3 3],1);
rgb = imfilter(rgb,G,'same');
 displayKinectRGB(rgb,h); 
 disp('Select top left and bottom right corners of the blue ball');  
 [x_blue,y_blue] = ginput(2);
  disp('Select top left and bottom right corners of the red ball');  
 [x_red,y_red] = ginput(2);
 
 
 hsv = rgb2hsv(rgb);
 blue_pixels = hsv(round(y_blue(1)):round(y_blue(2)), round(x_blue(1)):round(x_blue(2)), :);
 red_pixels = hsv(round(y_red(1)):round(y_red(2)), round(x_red(1)):round(x_red(2)),:);
 
 blue_h = double(blue_pixels(:,:,1));
 red_h = double(red_pixels(:,:,1));
 blue_h = blue_h(:);
 red_h = red_h(:);
 
 red_s = double(red_pixels(:,:,2));
 blue_s = double(blue_pixels(:,:,2));
 blue_s = blue_s(:);
 red_s = red_s(:);

 red_v = double(red_pixels(:,:,3));
 blue_v = double(blue_pixels(:,:,3));
 blue_v = blue_v(:);
 red_v = red_v(:);


 
 sigma_const = 0.5;
 sigma_const_min = 1.5;
 
 
 red_h_rng = [median(red_h)-sigma_const*std(red_h), median(red_h)+sigma_const*std(red_h)];
 blue_h_rng = [median(blue_h)-sigma_const*std(blue_h), median(blue_h)+sigma_const*std(blue_h)];
 
 blue_v_min = median(blue_v) - 1.5*sigma_const_min*std(blue_v);
 red_v_min = median(red_v) - sigma_const_min*std(red_v);
 
 blue_s_min = median(blue_s) - sigma_const_min*std(blue_s);
 red_s_min = median(red_s) - sigma_const_min*std(red_s);
 
 calibStruct.red_h_rng = red_h_rng;
calibStruct.blue_h_rng = blue_h_rng;

calibStruct.blue_v_min = blue_v_min;
calibStruct.red_v_min = red_v_min;

calibStruct.blue_s_min = blue_s_min;
calibStruct.red_s_min = red_s_min;





hsv = rgb2hsv(rgb);

 red_region = hsv(:,:,1) >= red_h_rng(1) & hsv(:,:,1) <= red_h_rng(2) & hsv(:,:,2) > red_s_min & hsv(:,:,3) > red_v_min;
 blue_region = hsv(:,:,1) >= blue_h_rng(1) & hsv(:,:,1) <= blue_h_rng(2)& hsv(:,:,2) > blue_s_min & hsv(:,:,3) > blue_v_min;

figure(10); 
[r,c] = size(red_region);                           %# Get the matrix size
hrr = imagesc((1:c)+0.5,(1:r)+0.5,red_region);            %# Plot the image
colormap(gray); 

figure(12); 
[r,c] = size(blue_region);                           %# Get the matrix size
hrb = imagesc((1:c)+0.5,(1:r)+0.5,blue_region);            %# Plot the image
colormap(gray); 

 
 while ishandle(h)

     
 [rgb,depth] = getKinectData(context);

 tic();    
[bestRedCentroid, bestBlueCentroid, bestRedVec_k, bestBlueVec_k] = localizeRover(context, rgb, depth, calibStruct, prevPixVec);
    prevPixVec = bestRedCentroid - bestBlueCentroid;
 toc()
%scatter(red_c, red_r, 'r*');
%scatter(blue_c, blue_r, 'b*');
if ishandle(scatterPointsR) 
delete(scatterPointsR);
delete(scatterPointsB);
end
set(h, 'CData', rgb);

%hsv = rgb2hsv(rgb);
% red_region = hsv(:,:,1) >= red_h_rng(1) & hsv(:,:,1) <= red_h_rng(2) & hsv(:,:,2) > red_s_min & hsv(:,:,3) > red_v_min;
% blue_region = hsv(:,:,1) >= blue_h_rng(1) & hsv(:,:,1) <= blue_h_rng(2)& hsv(:,:,2) > blue_s_min & hsv(:,:,3) > blue_v_min;

%set(hrr, 'CData', red_region);
%set(hrb, 'CData', blue_region);


%hold(fig, 'on');
hold(axesHandles, 'on');
if ~isnan(bestRedCentroid(1))
scatterPointsR = scatter(bestRedCentroid(1), bestRedCentroid(2), 'y*', 'Parent', axesHandles);
scatterPointsB = scatter(bestBlueCentroid(1), bestBlueCentroid(2), 'y*', 'Parent', axesHandles);
end

pause(0.01);

end 

mxNiDeleteContext(context);

