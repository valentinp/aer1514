addpath('./kinect/Mex');
addpath('./utils');
% Constants
height = 480;               % pixels
width = 640;                % pixels
%Extract rgb and depth image
[context, option] = createKinectContext(true);

%Set up GUI
h = figure;
h = imagesc(zeros(height,width,3,'uint8'));
hold on;

%Intialize
scatterPointsR = [];
scatterPointsB = [];


while (ishandle(h))
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
thresh = 20;       % inlier error threshold (radius meas. in pixels)
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

redVec = kinectPoints_k(bestRedCentroid(2), bestRedCentroid(1));
blueVec = kinectPoints_k(bestBlueCentroid(2), bestBlueCentroid(1));
lateralVec = blueVec - redVec;
disp(lateralVec)
%Transform this vector into the ground plane
lateralVec_g = T_gk*lateralVec;
roverLoc = lateralVec_g(1:2);
%disp(roverLoc)
    pause(0.03);
end


    % Clean up
    mxNiDeleteContext(context);