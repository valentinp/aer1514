function displayLocalization(figHandle, rgb, calibStruct)
%DISPLAYLOCALIZATION Displays localization according to the current
%calibration

red_h_rng = calibStruct.red_h_rng;
blue_h_rng = calibStruct.blue_h_rng;

blue_v_min = calibStruct.blue_v_min;
red_v_min = calibStruct.red_v_min;

blue_s_min = calibStruct.blue_s_min;
red_s_min = calibStruct.red_s_min;

hsv = rgb2hsv(rgb);

 red_region = hsv(:,:,1) >= red_h_rng(1) & hsv(:,:,1) <= red_h_rng(2) & hsv(:,:,2) > red_s_min & hsv(:,:,3) > red_v_min;
 blue_region = hsv(:,:,1) >= blue_h_rng(1) & hsv(:,:,1) <= blue_h_rng(2)& hsv(:,:,2) > blue_s_min & hsv(:,:,3) > blue_v_min;
 

if sum(red_region) < 5
    disp('WARNING: No red pixels found'); 
    return;
end
if sum(blue_region) < 5
    disp('WARNING: No blue pixels found'); 
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

%a = axes('Parent', figHandle);
hold(figHandle, 'on');
delete(findobj(figHandle, 'type', 'line'));
plot(bestRedCentroid(1), bestRedCentroid(2), 'y*', 'Parent', figHandle);
plot(bestBlueCentroid(1), bestBlueCentroid(2), 'y*','Parent', figHandle);


end

