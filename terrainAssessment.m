function terrain = terrainAssessment(context, option, mode)
% mode = 0 --> manual ground region selection for plane fit
% mode = 1 --> automatic ground plane fit

% clear all; close all;
    addpath('./kinect/Mex');
    addpath('./utils');
    
    % Constants
    height = 480;               % pixels
    width = 640;                % pixels
    gridSpacing = 0.10;         % meters
    floorPlaneTol = 0.50;       % meters
    minPointsToFitPlane = 20;   % # points
    
    % Set up U,V meshgrid for image
    u = 1:width;  
    v = 1:height; 
    [U,V] = meshgrid(u,v);
    U = U(:);
    V = V(:);
    
%     [context, option] = createKinectContext(true);
    [rgb,depth] = getKinectData(context, option);
    kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;  % height x width x 3 (meters)
    kinectPoints_k = reshape(kinectPoints_k, [(width*height) 3]);              % (height x width) x 3
    kinectPoints_k = kinectPoints_k';                                          % 3 x (height x width)
    
    if mode == 0
        % Manual ground region selection fot plane fitting        
        h = figure;
        h = imagesc(zeros(height,width,'uint16'));
        displayKinectDepth(depth,h);

        % Select coordinates of 2 ground points
        gotGoodGroundPoints = false;    
        while ~gotGoodGroundPoints
            disp('Select bottom-left and top-right points of a region on the ground');
            [uGround,vGround] = ginput(2);    

            uGround = round(uGround);
            vGround = round(vGround);

            % Basic error checking in case depth image is screwy
            gotGoodGroundPoints = depth(vGround(1),uGround(1)) > 0 && depth(vGround(2),uGround(2)) > 0;
        end

        % Grab all points in the rectangle
        planeFitMask = U >= min(uGround) & U <= max(uGround) & V >= min(vGround) & V <= max(vGround);
        groundPlanePoints = kinectPoints_k(:,planeFitMask);
        close(h);
        
    else
        % Automatic plane fit using RANSAC
        if mode ~= 1
            disp('Invalid mode. Valid modes are 0 (manual) and 1 (auto).');
            disp('Defaulting to automatic fit.');
        end
        
        groundPlanePoints = kinectPoints_k(:, depth(:) > 0);
    end
    
    [groundA, groundB, groundC] = fitPlaneToPoints(groundPlanePoints(1,:), groundPlanePoints(2,:), groundPlanePoints(3,:), 0.9999, 0.2);

    % Some points in the plane (columns of this matrix)
    groundPoints_k = [1,                  0,                  0;
                    0,                  1,                  0;
                    groundA+groundB,    groundA+groundC,    groundA];

    % Compute basis vectors for ground plane
    vec1_k = groundPoints_k(:,1) - groundPoints_k(:,3);
    vec2_k = groundPoints_k(:,2) - groundPoints_k(:,3);
    % Orthogonalize (Gram-Schmidt)
    vec2_k = vec2_k - (dot(vec1_k, vec2_k)/dot(vec1_k, vec1_k)) * vec1_k;
    % Normalize
    vec1_k = vec1_k / norm(vec1_k);
    vec2_k = vec2_k / norm(vec2_k);    
    % Ground plane to Kinect rotation
    R_kg = [vec1_k, vec2_k, cross(vec1_k,vec2_k)];
    t_gk_k = groundPoints_k(:,3);
    T_gk = [R_kg'       ,   -R_kg' * t_gk_k;
            zeros(1,3)  ,   1               ];
    T_kg = inv(T_gk);

    % Change basis of Kinect point cloud
    kinectPoints_k = cart2homo(kinectPoints_k);    
    kinectPoints_g = T_gk * kinectPoints_k;
    kinectPoints_g = homo2cart(kinectPoints_g);

    floorPoints_g = kinectPoints_g(:,abs(kinectPoints_g(3,:)) < floorPlaneTol);

%     h = figure;
%     h = imagesc(zeros(height,width,3,'uint8'));
%     displayKinectRGB(rgb,h); hold on;
%     scatter(floorPoints_k(1,:),floorPoints_k(2,:),'.');

%     figure(100); clf;
%     scatter3(floorPoints_g(1,1:50:end),floorPoints_g(2,1:50:end),floorPoints_g(3,1:50:end),'.');
%     xlabel('x');ylabel('y');zlabel('z');

    % Set up grid for local plane fitting
    gridEdgesX = min(floorPoints_g(1,:)) : gridSpacing : max(floorPoints_g(1,:));
    gridEdgesY = min(floorPoints_g(2,:)) : gridSpacing : max(floorPoints_g(2,:));
    gridSize = [numel(gridEdgesY)-1, numel(gridEdgesX)-1];

    % Represent each plane with parameters a,b,c
    % s.t. a + bx + cy = z
    gridPlanesA = zeros(gridSize);
    gridPlanesB = zeros(gridSize);
    gridPlanesC = zeros(gridSize);

    % Also keep track of max slope for path planning
    planeMaxSlope = zeros(gridSize); 

    tic;
    for i = 1:gridSize(1)-1
        for j = 1:gridSize(2)-1
            % Grab all points within the current grid cell
            planeMask = floorPoints_g(1,:) >= gridEdgesX(j) & floorPoints_g(1,:) <= gridEdgesX(j+1) ...
                        & floorPoints_g(2,:) >= gridEdgesY(i) & floorPoints_g(2,:) <= gridEdgesY(i+1);                    

            % sum(planeMask)
            % is the number of "floor" points within the current cell
            if sum(planeMask) >= minPointsToFitPlane
                planePoints = floorPoints_g(:,planeMask);

                % Get fitted plane parameters
                [gridPlanesA(i,j), gridPlanesB(i,j), gridPlanesC(i,j)] = fitPlaneToPoints(planePoints(1,:)', planePoints(2,:)', planePoints(3,:)');
                planeMaxSlope(i,j) = acosd(1/(gridPlanesB(i,j)^2 + gridPlanesC(i,j)^2 + 1));
            else
                planeMaxSlope(i,j) = 90;
            end
        end
    end
    toc;

    % Package the assessed terrain into a handy structure 
    terrain.T_gk = T_gk;
    terrain.T_kg = T_kg;
    terrain.gridEdgesX = gridEdgesX;
    terrain.gridEdgesY = gridEdgesY;
    terrain.cellMiddlesX = terrain.gridEdgesX(1:end-1) + 0.5*(terrain.gridEdgesX(2:end) - terrain.gridEdgesX(1:end-1));
    terrain.cellMiddlesY = terrain.gridEdgesY(1:end-1) + 0.5*(terrain.gridEdgesY(2:end) - terrain.gridEdgesY(1:end-1));
    terrain.gridSize = gridSize;
    terrain.gridSpacing = gridSpacing;
    terrain.gridPlanesA = gridPlanesA;
    terrain.gridPlanesB = gridPlanesB;
    terrain.gridPlanesC = gridPlanesC;
    terrain.planeMaxSlope = planeMaxSlope;
    terrain.safeCells = findSafeCells(terrain);

    % Clean up
%     mxNiDeleteContext(context);
end

function safeCells = findSafeCells(terrain)
    maxSlope = 30;      % degrees
    markNeighboursOfUnsafeCellsAsUnsafe = false;
    
    % Each column is the direction of a neighbouring cell
    neighbourDirs = [1 1 0 -1 -1 -1 0 1;
                     0 1 1 1 0 -1 -1 -1];    
    
    % Initialize
    safeCells = true(terrain.gridSize);
    
    for i = 1:terrain.gridSize(1)
        for j = 1:terrain.gridSize(2)
            maxSlopeToNeighbour = 0;
            cellCentre = [terrain.cellMiddlesX(j),terrain.cellMiddlesY(i),0];
            cellCentre(3) = terrain.gridPlanesA(i,j) + terrain.gridPlanesB(i,j)*cellCentre(1) + terrain.gridPlanesC(i,j)*cellCentre(2); 
            for n = 1:8
                iAdj = i + neighbourDirs(1,n);
                jAdj = j + neighbourDirs(2,n);

                if(iAdj >= 1 && iAdj <= terrain.gridSize(1)...
                        && jAdj >= 1 && jAdj <= terrain.gridSize(2))
                    
                    cellCentreAdj = [terrain.cellMiddlesX(jAdj),terrain.cellMiddlesY(iAdj),0];
                    cellCentreAdj(3) = terrain.gridPlanesA(iAdj,jAdj) + terrain.gridPlanesB(iAdj,jAdj)*cellCentreAdj(1) + terrain.gridPlanesC(iAdj,jAdj)*cellCentreAdj(2);
                    
                    neighbourVec = cellCentreAdj - cellCentre;
                    neighbourVecCyl = [norm(neighbourVec(1:2)), neighbourVec(3)]; % [r,z]
                    slopeToNeighbour = abs(acosd(dot([1,0],neighbourVecCyl)/norm(neighbourVecCyl)));
                    maxSlopeToNeighbour = max(maxSlopeToNeighbour, slopeToNeighbour);
                end
            end
            
            looksSafe = terrain.planeMaxSlope(i,j) <= maxSlope && maxSlopeToNeighbour <= maxSlope;

            if ~looksSafe
                if markNeighboursOfUnsafeCellsAsUnsafe
                    for n = 1:8
                        iAdj = i + neighbourDirs(1,n);
                        jAdj = j + neighbourDirs(2,n);

                        if(iAdj >= 1 && iAdj <= terrain.gridSize(1)...
                                && jAdj >= 1 && jAdj <= terrain.gridSize(2))
                            safeCells(iAdj,jAdj) = false;
                        end
                    end
                end
                safeCells(i,j) = false;
            end            
            
        end
    end
end