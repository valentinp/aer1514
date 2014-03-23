function displayLocalization(figHandle, rgb, calibStruct )
%DISPLAYLOCALIZATION Displays localization according to the current
%calibration

red_r_rng = calibStruct.red_r_rng;
red_g_rng = calibStruct.red_g_rng;
red_b_rng = calibStruct.red_b_rng;

blue_r_rng = calibStruct.blue_r_rng;
blue_g_rng = calibStruct.blue_g_rng;
blue_b_rng = calibStruct.blue_b_rng;

blue_br_rng = calibStruct.blue_br_rng;
blue_rg_rng = calibStruct.blue_rg_rng;
blue_gb_rng = calibStruct.blue_gb_rng;

red_br_rng = calibStruct.red_br_rng;
red_rg_rng = calibStruct.red_rg_rng;
red_gb_rng = calibStruct.red_gb_rng;


red_region = rgb(:,:,1) > red_r_rng(1) & rgb(:,:,1) < red_r_rng(2) & rgb(:,:,2) > red_g_rng(1) & rgb(:,:,2) < red_g_rng(2) & rgb(:,:,3) > red_b_rng(1) & rgb(:,:,3) < red_b_rng(2) & ... 
double(rgb(:,:,3))./double(rgb(:,:,1)) > red_br_rng(1) & double(rgb(:,:,3))./double(rgb(:,:,1)) < red_br_rng(2) & ... 
double(rgb(:,:,1))./double(rgb(:,:,2)) > red_rg_rng(1) & double(rgb(:,:,1))./double(rgb(:,:,2)) < red_rg_rng(2) & ... 
double(rgb(:,:,2))./double(rgb(:,:,3)) > red_gb_rng(1) & double(rgb(:,:,2)./rgb(:,:,3)) < red_gb_rng(2);

blue_region = rgb(:,:,1) > blue_r_rng(1) & rgb(:,:,1) < blue_r_rng(2) & rgb(:,:,2) > blue_g_rng(1) & rgb(:,:,2) < blue_g_rng(2) & rgb(:,:,3) > blue_b_rng(1) & rgb(:,:,3) < blue_b_rng(2) & ... 
double(rgb(:,:,3))./double(rgb(:,:,1)) > blue_br_rng(1) & double(rgb(:,:,3))./double(rgb(:,:,1)) < blue_br_rng(2) & ... 
double(rgb(:,:,1))./double(rgb(:,:,2)) > blue_rg_rng(1) & double(rgb(:,:,1))./double(rgb(:,:,2)) < blue_rg_rng(2) & ... 
double(rgb(:,:,2))./double(rgb(:,:,3)) > blue_gb_rng(1) & double(rgb(:,:,2))./double(rgb(:,:,3)) < blue_gb_rng(2);


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
disp(bestRedCentroid)
disp(bestBlueCentroid)
scatter(figHandle,bestRedCentroid(1), bestRedCentroid(2), 'y*');
scatter(figHandle,bestBlueCentroid(1), bestBlueCentroid(2), 'y*');


end

