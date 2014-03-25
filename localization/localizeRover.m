function T_rg = localizeRover(context, rgb, depth, calibStruct, T_gk)

% Constants
ballDiameter = 0.05; % meters
depthOffset = 2*ballDiameter; % Seems to work better with 2*ballDiamater than 1*

red_h_rng = calibStruct.red_h_rng;
blue_h_rng = calibStruct.blue_h_rng;

blue_v_min = calibStruct.blue_v_min;
red_v_min = calibStruct.red_v_min;

blue_s_min = calibStruct.blue_s_min;
red_s_min = calibStruct.red_s_min;

hsv = rgb2hsv(rgb);

 red_region = hsv(:,:,1) >= red_h_rng(1) & hsv(:,:,1) <= red_h_rng(2) & hsv(:,:,2) > red_s_min & hsv(:,:,3) > red_v_min;
 blue_region = hsv(:,:,1) >= blue_h_rng(1) & hsv(:,:,1) <= blue_h_rng(2)& hsv(:,:,2) > blue_s_min & hsv(:,:,3) > blue_v_min;

 

kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;  % height x width x 3 (meters)


if sum(red_region) < 5
    disp('WARNING: No red pixels found'); 
    T_rg = NaN;
    return;
end
if sum(blue_region) < 5
    disp('WARNING: No blue pixels found'); 
    T_rg = NaN;
    return;
end

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
% if ishandle(scatterPointsR) 
% delete(scatterPointsR);
% delete(scatterPointsB);
% end

% scatterPointsR = scatter(bestRedCentroid(1), bestRedCentroid(2), 'y*');
% scatterPointsB = scatter(bestBlueCentroid(1), bestBlueCentroid(2), 'y*');

redVec_k = kinectPoints_k(bestRedCentroid(2), bestRedCentroid(1), :);
blueVec_k = kinectPoints_k(bestBlueCentroid(2), bestBlueCentroid(1), :);

redVec_k = redVec_k(:);
blueVec_k = blueVec_k(:);

redVec_k(3) = redVec_k(3) + depthOffset;
blueVec_k(3) = blueVec_k(3) + depthOffset;

redVec_g = homo2cart(T_gk*cart2homo(redVec_k));
blueVec_g = homo2cart(T_gk*cart2homo(blueVec_k));

lateralVec_g = blueVec_g - redVec_g;
roverPos_g = 0.5*lateralVec_g + redVec_g; % point between the two balls

lateralVec_g(3) = 0;
roverPos_g(3) = 0;

%Ensure that the distance between blue balls makes sense
if norm(lateralVec_g) > 0.5
    T_rg = NaN;
    return;
end

rotLateralVec_g = rotzd(90)*lateralVec_g;
R_gr = [ normalize(rotLateralVec_g), normalize(-1*lateralVec_g), [0;0;1] ]; % x is forward in rover frame
R_rg = R_gr';
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

