function T_rg = localizeRover(context, option, T_gk)
addpath('./kinect/Mex');
addpath('./utils');
% Constants
height = 480;               % pixels
width = 640;                % pixels
%Extract rgb and depth image
% close all;
% [context, option] = createKinectContext(true);

%Set up GUI
figure(1);
h = imagesc(zeros(height,width,3,'uint8'));
hold on;

%Intialize
scatterPointsR = [];
scatterPointsB = [];


% while (ishandle(h))
      [rgb,depth] = getKinectData(context, option);
        %Plot raw RGB image
        displayKinectRGB(rgb,h); 

kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;  % height x width x 3 (meters)
%Extract red and blue regions
red_region = rgb(:,:,1)./(rgb(:,:,2) + 0.1) > 3 & rgb(:,:,1)./(rgb(:,:,3)+0.1) > 3;
blue_region = rgb(:,:,3)./(rgb(:,:,2) + 0.1) > 1.5 & rgb(:,:,3)./(rgb(:,:,1)+0.1) > 3;

[red_r,red_c] = find(red_region);
[blue_r,blue_c] = find(blue_region);


% Use RANSAC to find the best centroid for the red and blue spheres
K = 200;
thresh = 15;       % inlier error threshold (radius meas. in pixels)
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

scatterPointsR = scatter(bestRedCentroid(1), bestRedCentroid(2), 'y*');
scatterPointsB = scatter(bestBlueCentroid(1), bestBlueCentroid(2), 'y*');

redVec_k = kinectPoints_k(bestRedCentroid(2), bestRedCentroid(1), :);
blueVec_k = kinectPoints_k(bestBlueCentroid(2), bestBlueCentroid(1), :);

redVec_k = redVec_k(:);
blueVec_k = blueVec_k(:);

redVec_g = homo2cart(T_gk*cart2homo(redVec_k));
blueVec_g = homo2cart(T_gk*cart2homo(blueVec_k));

lateralVec_g = blueVec_g - redVec_g;
roverPos_g = 0.5*lateralVec_g + redVec_g; % point between the two balls

lateralVec_g(3) = 0;
roverPos_g(3) = 0;

rotLateralVec_g = rotzd(90)*lateralVec_g;
R_rg = [ normalize(rotLateralVec_g), normalize(lateralVec_g), [0;0;1] ]; % x is forward in rover frame

T_rg = [R_rg -R_rg*roverPos_g;
        0,0,0,1];

% roverPos_k(1,2,:) = homo2cart(T_gk \ cart2homo(roverPos_g));
% roverPos_k(1,1,:) = [0,0,0];
% roverPos_k_projective = mxNiConvertRealWorldToProjective(context, roverPos_k*1000);
% plot(roverPos_k_projective(1,:,1), roverPos_k_projective(1,:,2), 'r');

% angle = acosd(dot(lateralVec_g,[1;0;0])/norm(lateralVec_g))
    
    % Clean up
%     mxNiDeleteContext(context);
end

