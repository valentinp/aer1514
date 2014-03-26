function [bestRedCentroid, bestBlueCentroid, redVec_k, blueVec_k] = localizeRover(context, rgb, depth, calibStruct)

% Constants

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

%  kinectPoints_k = mxNiDepthRealWorld(context) / 1000;
%  kinectPoints_k=permute(kinectPoints_k,[2 1 3]);

if sum(red_region) < 5
    bestRedCentroid = NaN;
    bestBlueCentroid = NaN;
    redVec_k = NaN;
    blueVec_k = NaN;
    disp('WARNING: No red pixels found'); 
    return;
end
if sum(blue_region) < 5
    bestRedCentroid = NaN;
    bestBlueCentroid = NaN;
    redVec_k = NaN;
    blueVec_k = NaN;
    disp('WARNING: No blue pixels found'); 
    return;
end

[red_r,red_c] = find(red_region);
[blue_r,blue_c] = find(blue_region);


% Use RANSAC to find the best centroid for the red and blue spheres
K = 50;
thresh = 5;       % inlier error threshold (radius meas. in pixels)
maxSearchIterations = 100; % max amount of times to search for radii that are close together
maxInliersB = 0;
maxInliersR = 0;

bestBlueCentroid = [0,0]';
bestRedCentroid = [0,0]';

    for k = 1:K
        
        % Set centroid
        
        %Ensure centroids are within 40 cm of each other
        sampleIndB = randi(size(blue_r,1));
        testBlueCentroid = [blue_c(sampleIndB); blue_r(sampleIndB)];

        for  search_i = 1:maxSearchIterations
            sampleIndR = randi(size(red_r,1));
            testRedCentroid = [red_c(sampleIndR); red_r(sampleIndR)];
            redVec_k = kinectPoints_k(testRedCentroid(2), testRedCentroid(1), :);
            blueVec_k = kinectPoints_k(testBlueCentroid(2), testBlueCentroid(1), :);

            redVec_k = redVec_k(:);
            blueVec_k = blueVec_k(:);

            ball_sep = norm(redVec_k - blueVec_k)/1000;
            %disp(ball_sep);
            if  ball_sep < 0.4
                break;
            end
        end
        
        
        
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

redVec_k = kinectPoints_k(bestRedCentroid(2), bestRedCentroid(1), :);
blueVec_k = kinectPoints_k(bestBlueCentroid(2), bestBlueCentroid(1), :);

end

