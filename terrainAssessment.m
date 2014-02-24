% function terrainAssessment
clear all; close all;
    addpath('./kinect/Mex');
    addpath('./utils');
    
    % Constants
    height = 480;               % pixels
    width = 640;                % pixels
    gridSize = 40;              % millimeters
    floorPlaneTol = 100;         % millimeters
    minPointsToFitPlane = 10;
    maxSlope = 15;              % degrees
    
    % Set up X,Y meshgrid for image
    x = 1:width;  
    y = 1:height; 
    [X,Y] = meshgrid(x,y);
    
    [context, option] = createKinectContext(true);
    [rgb,depth] = getKinectData(context, option);
     
    h = figure;
    h = imagesc(zeros(height,width,'uint16'));
    displayKinectDepth(depth,h);
    
    % Select coordinates of 2 ground points
    gotGoodGroundPoints = false;    
    while ~gotGoodGroundPoints
        disp('Select bottom-left and top-right points of a region on the ground');
        [xGround,yGround] = ginput(2);    
        
        xGround = round(xGround);
        yGround = round(yGround);
        
        % Basic error checking in case depth image is screwy
        gotGoodGroundPoints = depth(yGround(1),xGround(1)) > 0 && depth(yGround(2),xGround(2)) > 0;
    end
    
    % Grab all points in the rectangle and fit a plane to them
    planeFitMask = X >= min(xGround) & X <= max(xGround) & Y >= min(yGround) & Y <= max(yGround);
    groundPlanePointsX = X(planeFitMask);
    groundPlanePointsY = Y(planeFitMask);
    groundPlanePointsZ = double(depth(planeFitMask));
    
    [groundA, groundB, groundC] = fitPlaneToPoints(groundPlanePointsX(:), groundPlanePointsY(:), groundPlanePointsZ(:));
    
    % Some points in the plane (columns of this matrix)
    groundPoints = [1,                  0,                  0;
                    0,                  1,                  0;
                    groundA+groundB,    groundA+groundC,    groundA];
                
    % Compute basis vectors for ground plane
    vec1 = groundPoints(:,2) - groundPoints(:,1);
    vec2 = groundPoints(:,3) - groundPoints(:,1);
    % Orthogonalize (Gram-Schmidt)
    vec2 = vec2 - (dot(vec1, vec2)/dot(vec1, vec1)) * vec1;
    % Normalize
    vec1 = vec1 / norm(vec1);
    vec2 = vec2 / norm(vec2);    
    % Ground plane to Kinect rotation
    R_kg = [vec1, vec2, cross(vec1,vec2)];
    t_gk_k = groundPoints(:,1);
    T_gk = [R_kg'       ,   -R_kg' * t_gk_k;
            zeros(1,3)  ,   1               ];
    T_kg = inv(T_gk);
    
    % Change basis of Kinect point cloud
    % Also only take points with valid depth data (i.e., depth > 0)
    kinectPoints_k(3,:) = double(depth(depth > 0));
    kinectPoints_k(2,:) = Y(depth > 0);
    kinectPoints_k(1,:) = X(depth > 0); 
    kinectPoints_k = cart2homo(kinectPoints_k);
    
    kinectPoints_g = T_gk * kinectPoints_k;
    kinectPoints_g = homo2cart(kinectPoints_g);
    
    floorPoints_g = kinectPoints_g(:,abs(kinectPoints_g(3,:)) < floorPlaneTol);    
    floorPoints_k = homo2cart( T_kg * cart2homo(floorPoints_g) );
    
%     h = figure;
%     h = imagesc(zeros(height,width,3,'uint8'));
%     displayKinectRGB(rgb,h); hold on;
%     scatter(floorPoints_k(1,:),floorPoints_k(2,:),'.');
    
%     figure(100); clf;
%     scatter3(floorPoints_g(1,1:50:end),floorPoints_g(2,1:50:end),floorPoints_g(3,1:50:end),'.');
%     xlabel('x');ylabel('y');zlabel('z');

    % Set up grid for local plane fitting
    gridEdgesX = min(floorPoints_g(1,:)) : gridSize : max(floorPoints_g(1,:));
    gridEdgesY = min(floorPoints_g(2,:)) : gridSize : max(floorPoints_g(2,:));
    [gridCornersX, gridCornersY] = meshgrid(gridEdgesX, gridEdgesY);
    
    % Represent each plane with parameters a,b,c
    % s.t. a + bx + cy = z
    gridPlanesA = zeros(size(gridCornersX)-1);
    gridPlanesB = zeros(size(gridCornersX)-1);
    gridPlanesC = zeros(size(gridCornersX)-1);
    
    h = figure;
    h = imagesc(zeros(height,width,3,'uint8'));
    displayKinectRGB(rgb,h); hold on;   
    
    for i = 1:numel(gridEdgesY)-1
        for j = 1:numel(gridEdgesX)-1
            % Grab all points within the current grid cell
            planeMask = floorPoints_g(1,:) >= gridCornersX(i,j) & floorPoints_g(1,:) <= gridCornersX(i+1,j+1) ...
                        & floorPoints_g(2,:) >= gridCornersY(i,j) & floorPoints_g(2,:) <= gridCornersY(i+1,j+1);                    
            
            % sum(planeMask) is the number of floor points within the
            % current cell
            if sum(planeMask) >= minPointsToFitPlane
                planePoints = floorPoints_g(:,planeMask);
                
                % Get fitted plane parameters
                [gridPlanesA(i,j), gridPlanesB(i,j), gridPlanesC(i,j)] = fitPlaneToPoints(planePoints(1,:)', planePoints(2,:)', planePoints(3,:)');

                % Display fitted planes in the Kinect RGB image
                planeMaxSlope = acosd(1/(gridPlanesB(i,j)^2 + gridPlanesC(i,j)^2 + 1));
                if planeMaxSlope < maxSlope
                    planeColour = 'g';
                else
                    planeColour = 'r';
                end

                planeCorners_g(1,:) = [gridCornersX(i,j), gridCornersX(i,j), gridCornersX(i+1,j+1), gridCornersX(i+1,j+1)];
                planeCorners_g(2,:) = [gridCornersY(i,j), gridCornersY(i+1,j+1), gridCornersY(i+1,j+1), gridCornersY(i,j)];
                planeCorners_g(3,:) = gridPlanesA(i,j) + gridPlanesB(i,j)*planeCorners_g(1,:) + gridPlanesC(i,j)*planeCorners_g(2,:);

                planeCorners_k = homo2cart(T_kg * cart2homo(planeCorners_g));

                patch(planeCorners_k(1,:), planeCorners_k(2,:), planeColour, 'FaceAlpha',0.5);
                drawnow;
            end
        end
    end
    
    % Clean up
    mxNiDeleteContext(context);
% end