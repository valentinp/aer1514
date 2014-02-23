% function terrainAssessment
clear all; close all;
    addpath('./kinect/Mex');
    addpath('./utils');
    
    % Constants
    gridSize = 5;   % pixels
    height = 480;   % pixels
    width = 640;    % pixels
    
    % Set up X,Y meshgrid for interpolation
    x = 0:width-1;  
    y = 0:height-1; 
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

        % Basic error checking in case depth image is screwy
        depthCheck = interp2(X,Y,double(depth),xGround,yGround);  
        gotGoodGroundPoints = sum(depthCheck <= 0) == 0;
    end
    
    % Grab all points in the rectangle and fit a plane to them
    planeFitMask = X >= min(xGround) & X <= max(xGround) & Y >= min(yGround) & Y <= max(yGround);
    groundPlanePointsX = X(planeFitMask);
    groundPlanePointsY = Y(planeFitMask);
    groundPlanePointsZ = double(depth(planeFitMask));
    
    [groundA, groundB, groundC] = fitPlaneToPoints(groundPlanePointsX(:), groundPlanePointsY(:), groundPlanePointsZ(:));
    
    % Some points in the plane
    xGround = [1;                   0;                  0];
    yGround = [0;                   1;                  0];
    zGround = [groundA+groundB;     groundA+groundC;    groundA];
    
    % Compute basis vectors for ground plane
    vec1 = [xGround(2) - xGround(1) ; yGround(2) - yGround(1); zGround(2) - zGround(1)];
    vec2 = [xGround(3) - xGround(1) ; yGround(3) - yGround(1); zGround(3) - zGround(1)];    
    % Orthogonalize (Gram-Schmidt)
    vec2 = vec2 - (dot(vec1, vec2)/dot(vec1, vec1)) * vec1;    
    % Normalize
    vec1 = vec1 / norm(vec1);
    vec2 = vec2 / norm(vec2);    
    % Ground plane to Kinect rotation
    R_kg = [vec1, vec2, cross(vec1,vec2)];
    t_gk_k = [xGround(1); yGround(1); zGround(1)];
    T_gk = [R_kg', -R_kg' * t_gk_k;
              0,0,0,1];
    T_kg = inv(T_gk);
    
    % Change basis of Kinect point cloud
    kinectPoints(3,:) = double(depth(depth > 0));
    kinectPoints(2,:) = Y(depth > 0);
    kinectPoints(1,:) = X(depth > 0); 
    kinectPoints = cart2homo(kinectPoints);
    
    kinectPoints = T_gk * kinectPoints;
    
    floorPoints = kinectPoints(:,abs(kinectPoints(3,:)) < 5);
    
    floorPointsGround = homo2cart(floorPoints);
    
    floorPoints = T_kg * floorPoints;
    floorPoints = homo2cart(floorPoints);
    
    h = figure;
    h = imagesc(zeros(height,width,3,'uint8'));
    displayKinectRGB(rgb,h); hold on;
    scatter(floorPoints(1,:),floorPoints(2,:),'.');
    
    figure(100); clf;
    scatter3(floorPointsGround(1,1:50:end),floorPointsGround(2,1:50:end),floorPointsGround(3,1:50:end),'.');
    xlabel('x');ylabel('y');zlabel('z');
%     minX = min(floorPoints(1,:)); minY = min(floorPoints(2,:));
%     maxX = max(floorPoints(1,:)); maxY = max(floorPoints(2,:));
%     
%     planePoints = [ minX, maxX, minX, maxX;
%                     minY, minY, maxY, maxY;
%                     0   , 0   , 0   ,   0;
%                     1   , 1   , 1   ,   1];
%     planePoints = T_gk_k * planePoints;
%     fill(planePoints(1,:), planePoints(2,:),'c');
    
    
%     xPlane = 0:0.1:10;
%     yPlane = 0:0.1:10;
%     [XPlane,YPlane] = meshgrid(xPlane, yPlane);
%     ZPlane = groundA + groundB*XPlane + groundC*YPlane;
%     
%     figure(100); mesh(XPlane,YPlane,ZPlane);
%     xlabel('x');ylabel('y');zlabel('z');
    
%     % Make grid for local plane fitting
%     groundGridXRange = min(groundPoints(1,:)) : gridSize : max(groundPoints(1,:));
%     groundGridYRange = min(groundPoints(2,:)) : gridSize : max(groundPoints(2,:));    
%     [groundGridX, groundGridY] = meshgrid(groundGridXRange, groundGridYRange);
%     
%     % Each finite plane is represented by 
%     % [x0; y0; z0; 
%     fittedGroundPlanes = zeros(6,numel(groundGridX));
%     % Fit planes to grid squares
%     for i = 1:size(groundGridXRange,2)
%         for j = 1:size(groundGridYRange,2)
%             
%         end
%     end
    
    % Clean up
    mxNiDeleteContext(context);
% end