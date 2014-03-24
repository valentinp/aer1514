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

%Set up GUI
fig = figure(1);
h = imagesc(zeros(height,width,3,'uint8'));
%Intialize
scatterPointsR = [];
scatterPointsB = [];

if ~exist('rgb', 'var')
    load('kinectRGB.mat');
end

%[context,option] = createKinectContext();

 %[rgb,depth] = getKinectData(context);
 displayKinectRGB(rgb,h); 
%  disp('Select top left and bottom right corners of the blue ball');  
%  [x_blue,y_blue] = ginput(2);
%   disp('Select top left and bottom right corners of the red ball');  
%  [x_red,y_red] = ginput(2);

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


 
 
 sigma_const = 0.2;
 
 red_h_rng = [median(red_h)-sigma_const*std(red_h), median(red_h)+sigma_const*std(red_h)];
 blue_h_rng = [median(blue_h)-sigma_const*std(blue_h), median(blue_h)+sigma_const*std(blue_h)];
 
 blue_v_min = median(blue_v) - std(blue_v);
 red_v_min = median(red_v) - std(red_v);
 
 blue_s_min = median(blue_s) - std(blue_s);
 red_s_min = median(red_s) - std(red_s);
 
 
 
 red_region = hsv(:,:,1) >= red_h_rng(1) & hsv(:,:,1) <= red_h_rng(2) & hsv(:,:,2) > red_s_min & hsv(:,:,3) > red_v_min;
 blue_region = hsv(:,:,1) >= blue_h_rng(1) & hsv(:,:,1) <= blue_h_rng(2)& hsv(:,:,2) > blue_s_min & hsv(:,:,3) > blue_v_min;
 
 
figure(10);
[r,c] = size(red_region);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,red_region);            %# Plot the image
colormap(gray);                              %# Use a gray colormap

figure(12);
[r,c] = size(blue_region);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,blue_region);            %# Plot the image
colormap(gray);


[red_r,red_c] = find(red_region);
[blue_r,blue_c] = find(blue_region);


% Use RANSAC to find the best centroid for the red and blue spheres
K = 100;
thresh = 10;       % inlier error threshold (radius meas. in pixels)
maxInliersB = 0;
maxInliersR = 0;

bestBlueCentroid = [0,0]';
bestRedCentroid = [0,0]';

    for k = 1:K
        sampleIndB = randi(size(blue_r,1));
        sampleIndR = randi(size(red_r,1));
       

        % Set centroid
        testBlueCentroid = [blue_c(sampleIndB); blue_r(sampleIndB)];
        testRedCentroid = [red_c(sampleIndR); red_r(sampleIndR)];

        errB = (blue_c - testBlueCentroid(1)).^2 + (blue_r - testBlueCentroid(2)).^2;
        errR = (red_c - testRedCentroid(1)).^2 + (red_r - testRedCentroid(2)).^2;
        
        numInliersB = sum(errB < thresh^2);
        numInliersR = sum(errR < thresh^2);

        % Keep track of the best solution
        if numInliersB > maxInliersB
            maxInliersB = numInliersB;
            bestBlueCentroid = testBlueCentroid;
        end
        if numInliersR > maxInliersR
            maxInliersR = numInliersR;
            bestRedCentroid = testRedCentroid;
        end
    end

    
%scatter(red_c, red_r, 'r*');
%scatter(blue_c, blue_r, 'b*');
if ishandle(scatterPointsR) 
delete(scatterPointsR);
delete(scatterPointsB);
end

%hold(fig, 'on');
axesHandles = get(fig, 'Children');
hold(axesHandles, 'on');
scatterPointsR = scatter(bestRedCentroid(1), bestRedCentroid(2), 'y*', 'Parent', axesHandles);
scatterPointsB = scatter(bestBlueCentroid(1), bestBlueCentroid(2), 'y*', 'Parent', axesHandles);

 
%mxNiDeleteContext(context);

