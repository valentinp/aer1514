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
figure;
h = imagesc(zeros(height,width,3,'uint8'));
hold on;

%Intialize
scatterPointsR = [];
scatterPointsB = [];

[context, option] = createKinectContext();

 [rgb,depth] = getKinectData(context, option);
 displayKinectRGB(rgb,h); 
 disp('Select top left and bottom right corners of the blue ball');  
 [x_blue,y_blue] = ginput(2);
  disp('Select top left and bottom right corners of the red ball');  
 [x_red,y_red] = ginput(2);

 
 blue_pixels = rgb(round(x_blue(1)):round(x_blue(2)), round(y_blue(1)):round(y_blue(2)), :);
 red_pixels = rgb(round(x_red(1)):round(x_red(2)), round(y_red(1)):round(y_red(2)),:);
 
 blue_r = double(blue_pixels(:,:,1));
 blue_g = double(blue_pixels(:,:,2));
 blue_b = double(blue_pixels(:,:,3));
 
 red_r = double(red_pixels(:,:,1));
 red_g = double(red_pixels(:,:,2));
 red_b = double(red_pixels(:,:,3));
 
 blue_r = blue_r(:);
 blue_g = blue_g(:);
 blue_b = blue_b(:);
 
 red_r = red_r(:);
 red_g = red_g(:);
 red_b = red_b(:);
 
 blue_br = double(blue_pixels(:,:,3)./blue_pixels(:,:,1));
 blue_rg = double(blue_pixels(:,:,1)./blue_pixels(:,:,2));
 blue_gb = double(blue_pixels(:,:,2)./blue_pixels(:,:,3));
 
 blue_br = blue_br(:);
 blue_rg = blue_rg(:);
 blue_gb = blue_gb(:);
 
 
 red_br = double(red_pixels(:,:,3)./red_pixels(:,:,1));
 red_rg = double(red_pixels(:,:,1)./red_pixels(:,:,2));
 red_gb = double(red_pixels(:,:,2)./red_pixels(:,:,3));
 
 red_br = red_br(:);
 red_rg = red_rg(:);
 red_gb = red_gb(:);
 
 blue_r_rng = [mean(blue_r)-std(blue_r), mean(blue_r)+std(blue_r)];
 blue_g_rng = [mean(blue_g)-std(blue_g), mean(blue_g)+std(blue_g)];
 blue_b_rng = [mean(blue_b)-std(blue_b), mean(blue_b)+std(blue_b)];

 blue_br_rng = [mean(blue_br)-std(blue_br), mean(blue_br)+std(blue_br)];
 blue_rg_rng = [mean(blue_rg)-std(blue_rg), mean(blue_rg)+std(blue_rg)];
 blue_gb_rng = [mean(blue_gb)-std(blue_gb), mean(blue_gb)+std(blue_gb)];
 
 red_r_rng = [mean(red_r)-std(red_r), mean(red_r)+std(red_r)];
 red_g_rng = [mean(red_g)-std(red_g), mean(red_g)+std(red_g)];
 red_b_rng = [mean(red_b)-std(red_b), mean(red_b)+std(red_b)];

 
 red_br_rng = [mean(red_br)-std(red_br), mean(red_br)+std(red_br)];
 red_rg_rng = [mean(red_rg)-std(red_rg), mean(red_rg)+std(red_rg)];
 red_gb_rng = [mean(red_gb)-std(red_gb), mean(red_gb)+std(red_gb)];
 
 
 
 
 
runWhile = true; 
 
while runWhile%(ishandle(h))
      [rgb,depth] = getKinectData(context, option);
        %Plot raw RGB image
        displayKinectRGB(rgb,h); 

kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;  % height x width x 3 (meters)
%Extract red and blue regions
red_region = ...
rgb(:,:,1) > red_r_rng(1) & rgb(:,:,1) < red_r_rng(2) & ... 
rgb(:,:,2) > red_g_rng(1) & rgb(:,:,2) < red_g_rng(2) & ... 
rgb(:,:,3) > red_b_rng(1) & rgb(:,:,3) < red_b_rng(2) & ... 
rgb(:,:,3)./rgb(:,:,1) > red_br_rng(1) & rgb(:,:,3)./rgb(:,:,1) < red_br_rng(2) & ... 
rgb(:,:,1)./rgb(:,:,2) > red_rg_rng(1) & rgb(:,:,1)./rgb(:,:,2) < red_rg_rng(2) & ... 
rgb(:,:,2)./rgb(:,:,3) > red_gb_rng(1) & rgb(:,:,2)./rgb(:,:,3) < red_gb_rng(2);

blue_region = ...
rgb(:,:,1) > blue_r_rng(1) & rgb(:,:,1) < blue_r_rng(2) & ... 
rgb(:,:,2) > blue_g_rng(1) & rgb(:,:,2) < blue_g_rng(2) & ... 
rgb(:,:,3) > blue_b_rng(1) & rgb(:,:,3) < blue_b_rng(2) & ... 
rgb(:,:,3)./rgb(:,:,1) > blue_br_rng(1) & rgb(:,:,3)./rgb(:,:,1) < blue_br_rng(2) & ... 
rgb(:,:,1)./rgb(:,:,2) > blue_rg_rng(1) & rgb(:,:,1)./rgb(:,:,2) < blue_rg_rng(2) & ... 
rgb(:,:,2)./rgb(:,:,3) > blue_gb_rng(1) & rgb(:,:,2)./rgb(:,:,3) < blue_gb_rng(2);


figure(10);
[r,c] = size(red_region);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,red_region);            %# Plot the image
colormap(gray);                              %# Use a gray colormap

figure(12);
[r,c] = size(blue_region);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,blue_region);            %# Plot the image
colormap(gray);


runWhile = false;

[red_r,red_c] = find(red_region);
[blue_r,blue_c] = find(blue_region);


% % Use RANSAC to find the best centroid for the red and blue spheres
% K = 100;
% thresh = 5;       % inlier error threshold (radius meas. in pixels)
% maxInliersB = 0;
% maxInliersR = 0;
% 
% bestBlueCentroid = [0,0]';
% bestRedCentroid = [0,0]';
% 
%     for k = 1:K
%         sampleIndB = randi(size(blue_r,1));
%         sampleIndR = randi(size(red_r,1));
%        
% 
%         % Set centroid
%         testBlueCentroid = [blue_c(sampleIndB); blue_r(sampleIndB)];
%         testRedCentroid = [red_c(sampleIndR); red_r(sampleIndR)];
% 
%         errB = (blue_c - testBlueCentroid(1)).^2 + (blue_r - testBlueCentroid(2)).^2;
%         errR = (red_c - testRedCentroid(1)).^2 + (red_r - testRedCentroid(2)).^2;
%         
%         numInliersB = sum(errB < thresh^2);
%         numInliersR = sum(errR < thresh^2);
% 
%         % Keep track of the best solution
%         if numInliersB > maxInliersB
%             maxInliersB = numInliersB;
%             bestBlueCentroid = testBlueCentroid;
%         end
%         if numInliersR > maxInliersR
%             maxInliersR = numInliersR;
%             bestRedCentroid = testRedCentroid;
%         end
%     end
% 
%     
% %scatter(red_c, red_r, 'r*');
% %scatter(blue_c, blue_r, 'b*');
% if ishandle(scatterPointsR) 
% delete(scatterPointsR);
% delete(scatterPointsB);
% end
% 
% scatterPointsR = scatter(bestRedCentroid(1), bestRedCentroid(2), 'y*');
% scatterPointsB = scatter(bestBlueCentroid(1), bestBlueCentroid(2), 'y*');
% 
% redVec = kinectPoints_k(bestRedCentroid(2), bestRedCentroid(1), :);
% blueVec = kinectPoints_k(bestBlueCentroid(2), bestBlueCentroid(1), :);
% 
% lateralVec = cart2homo(0.5*(blueVec(:) - redVec(:)) + redVec(:));
% %Transform this vector into the ground plane
% % lateralVec_g = homo2cart(T_gk*lateralVec);
% % roverLoc = lateralVec_g;
% % disp(roverLoc)
% pause(0.01);
 end
mxNiDeleteContext(context);

