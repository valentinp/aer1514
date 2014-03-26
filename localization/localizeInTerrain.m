function [T_rg] = localizeInTerrain(redVec_k,blueVec_k, T_gk)

ballDiameter = 0.05; % meters
depthOffset = 0; %2*ballDiameter;
ballHeight = 0.3; % meters

%Localize the rover in the terrain
redVec_k = redVec_k(:);
blueVec_k = blueVec_k(:);

redVec_k(3) = redVec_k(3) + depthOffset;
blueVec_k(3) = blueVec_k(3) + depthOffset;

redVec_g = homo2cart(T_gk*cart2homo(redVec_k));
blueVec_g = homo2cart(T_gk*cart2homo(blueVec_k));

% Correction if we're in the part of the depth image that we're faking
% if(redVec_g(3) < 2*ballDiameter || blueVec_g(3) < 2*ballDiameter)
%     kinectVec_g = T_gk * [0;0;0;1];
%     
%     redVec_k(3) = redVec_k(3) * (1 - ballHeight/kinectVec_g(3));
%     blueVec_k(3) = blueVec_k(3) * (1 - ballHeight/kinectVec_g(3));
%     
%     redVec_g = homo2cart(T_gk*cart2homo(redVec_k));
%     blueVec_g = homo2cart(T_gk*cart2homo(blueVec_k));
% end

lateralVec_g = blueVec_g - redVec_g;
roverPos_g = 0.5*lateralVec_g + redVec_g; % point between the two balls

lateralVec_g(3) = 0;
roverPos_g(3) = 0;

%Ensure that the distance between blue balls makes sense
if norm(lateralVec_g) > 1
    T_rg = NaN;
    return;
end

rotLateralVec_g = rotzd(90)*lateralVec_g;
R_gr = [ normalize(rotLateralVec_g), normalize(-1*lateralVec_g), [0;0;1] ]; % x is forward in rover frame
R_rg = R_gr';
T_rg = [R_rg -R_rg*roverPos_g;
        0,0,0,1];
end