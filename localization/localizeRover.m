function [bestRedCentroid, bestBlueCentroid, bestRedVec_k, bestBlueVec_k] = localizeRover(context, rgb, depth, calibStruct, prevPixVec)

%Gaussian smooth the RGB input
%# Filter it
%G = fspecial('gaussian',[3 3],1);
%rgb = imfilter(rgb,G,'same');

bestRedCentroid = NaN;
bestBlueCentroid = NaN;
bestRedVec_k = NaN;
bestBlueVec_k = NaN;

red_h_rng = calibStruct.red_h_rng;
blue_h_rng = calibStruct.blue_h_rng;

blue_v_min = calibStruct.blue_v_min;
red_v_min = calibStruct.red_v_min;

blue_s_min = calibStruct.blue_s_min;
red_s_min = calibStruct.red_s_min;

hsv = rgb2hsv(rgb);

 red_region = hsv(:,:,1) >= red_h_rng(1) & hsv(:,:,1) <= red_h_rng(2) & hsv(:,:,2) > red_s_min & hsv(:,:,3) > red_v_min;
 blue_region = hsv(:,:,1) >= blue_h_rng(1) & hsv(:,:,1) <= blue_h_rng(2)& hsv(:,:,2) > blue_s_min & hsv(:,:,3) > blue_v_min;


if sum(red_region) < 2
   disp('WARNING: No red pixels found'); 
    return;
end
if sum(blue_region) < 2
    disp('WARNING: No blue pixels found'); 
    return;
end

[red_r,red_c] = find(red_region);
[blue_r,blue_c] = find(blue_region);


% Use RANSAC to find the best centroid for the red and blue spheres
K = 200;
thresh = 5;       % inlier error threshold (radius meas. in pixels)
%maxSearchIterations = 30; % max amount of times to search for radii that are close together
maxInliersB = 0;
maxInliersR = 0;

    for k = 1:K
        %Ensure centroids are within 40 cm of each other
        sampleIndB = randi(size(blue_r,1));
        testBlueCentroid = [blue_c(sampleIndB); blue_r(sampleIndB)];
        sampleIndR = randi(size(red_r,1));
        testRedCentroid = [red_c(sampleIndR); red_r(sampleIndR)];
%             if ~isnan(prevPixVec)
%                 cosChange = normalize(prevPixVec)'*normalize(testRedCentroid - testBlueCentroid);
%             else
%                 cosChange = 1;
%             end
%         
            if  norm(testRedCentroid - testBlueCentroid) > 350  %Less than 30 degree change
                continue;
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

if ~isnan(bestRedCentroid(1)) && ~isnan(bestBlueCentroid(1))
    kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;  % height x width x 3 (meters)
    bestRedVec_k = kinectPoints_k(bestRedCentroid(2), bestRedCentroid(1), :);
    bestBlueVec_k = kinectPoints_k(bestBlueCentroid(2), bestBlueCentroid(1), :);
    bestRedVec_k = reshape(bestRedVec_k, [3 1]);
    bestBlueVec_k = reshape(bestBlueVec_k, [3 1]);
    ballSep = norm(bestRedVec_k - bestBlueVec_k);
    if ballSep < 0.25 || ballSep > 0.7
        bestRedCentroid = NaN;
        bestBlueCentroid = NaN;
        bestRedVec_k = NaN;
        bestBlueVec_k = NaN;
    end
end

end

