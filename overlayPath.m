function overlayPath(h,waypoints,terrain,context)
    height = 480;
    width = 640;
     
    chevronTemplate = [ -1 0 1 0;
                        -1 1 -1 0 ] * 0.5 * terrain.gridSpacing;
    
    for n = 1:size(waypoints,2)        
        if n < size(waypoints,2)
            segmentVec = waypoints(:,n+1) - waypoints(:,n);
            t = real(acosd(dot([0;1],segmentVec)/norm(segmentVec)));
            
            if segmentVec(1) < 0
                t = -t;
            end
        end
        
        chevronTemplate_rot = [cosd(t), sind(t); -sind(t), cosd(t)] * chevronTemplate;
        
        chevronPoints_g = zeros(3,4);
        chevronPoints_g(2,:) = waypoints(2,n) + chevronTemplate_rot(2,:);
        chevronPoints_g(1,:) = waypoints(1,n) + chevronTemplate_rot(1,:);
        
        chevronPoints_k = homo2cart(terrain.T_kg*cart2homo(chevronPoints_g));
        chevronPoints_k = reshape(chevronPoints_k', [1 4 3]);
        chevronPoints_k_projective = mxNiConvertRealWorldToProjective(context, chevronPoints_k*1000); % needs to be in mm
        chevronPoints_k_projective = reshape(chevronPoints_k_projective, [4 3]);
        
        h = patch(chevronPoints_k_projective(:,1), chevronPoints_k_projective(:,2), 'b', 'FaceAlpha', 0.8);
    end
end