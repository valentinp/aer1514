function overlayTerrainGrid(h, terrain)
    figure(h);
    
    height = 480;
    width = 640;
    
    for i = 1:terrain.gridSize(1)-1
        for j = 1:terrain.gridSize(2)-1
            % Display fitted planes in the Kinect RGB image
            if planeMaxSlope(i,j) < maxSlope
                planeColour = 'g';
            else
                planeColour = 'r';
            end

            % Keep the visualization clean -- don't plot the practically
            % vertical planes
            if planeMaxSlope(i,j) <= maxSlopeToDisplay
                planeCorners_g(1,:) = [gridEdgesX(j), gridEdgesX(j), gridEdgesX(j+1), gridEdgesX(j+1)];
                planeCorners_g(2,:) = [gridEdgesY(i), gridEdgesY(i+1), gridEdgesY(i+1), gridEdgesY(i)];
                planeCorners_g(3,:) = gridPlanesA(i,j) + gridPlanesB(i,j)*planeCorners_g(1,:) + gridPlanesC(i,j)*planeCorners_g(2,:);

                planeCorners_k = homo2cart(T_kg * cart2homo(planeCorners_g));
                planeCorners_k = reshape(planeCorners_k', [1 4 3]);
                planeCorners_k_projective = mxNiConvertRealWorldToProjective(context, planeCorners_k*1000); % needs it in mm
                planeCorners_k_projective = reshape(planeCorners_k_projective, [4 3]);

                % NOTE: If a point projects to a negative pixel coordinate,
                % it wraps around to 2^16 - coord
                % Just don't plot these ones
                if sum(~(planeCorners_k_projective(:,1) < width & planeCorners_k_projective(:,2) < height)) == 0
                    patch(planeCorners_k_projective(:,1), planeCorners_k_projective(:,2), planeColour, 'FaceAlpha',0.2);
                    %drawnow;  % Caution: drawing at every iteration slows
                               % down this loop by a factor of 10!
                end
            end
        end
    end
end