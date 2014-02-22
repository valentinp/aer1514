% function terrainAssessment
    addpath('./kinect/Mex');
    
    % Constants
    gridSize = 5;   % pixels
    height = 480;   % pixels
    width = 640;    % pixels
    
    % Set up X,Y meshgrid for interpolation
    x = 0:639;  % pixels
    y = 0:479;  % pixels
    [X,Y] = meshgrid(x,y);
    
    [context, option] = createKinectContext(true);
    [rgb,depth] = getKinectData(context, option);
    
    h = figure;
    h = imagesc(zeros(height,width,3,'uint8'));
    displayKinectRGB(rgb,h);
    
    % Select coordinates of 3 ground points
    gotGoodGroundPoints = false;    
    while ~gotGoodGroundPoints
        disp('Select three points on the ground');
        [xGround,yGround] = ginput(3);    
        zGround = interp2(X,Y,double(depth),xGround,yGround);
    
        % Basic error checking in case depth image is screwy
        gotGoodGroundPoints = sum(zGround <= 0) == 0;
    end
    
    % Compute basis vectors for ground plane
    vec1 = [xGround(2) - xGround(1) ; yGround(2) - yGround(1); zGround(2) - zGround(1)];
    vec2 = [xGround(3) - xGround(1) ; yGround(3) - yGround(1); zGround(3) - zGround(1)];    
    % Orthogonalize (Gram-Schmidt)
    vec2 = vec2 - (dot(vec1, vec2)/dot(vec1, vec1)) * vec1;    
    % Normalize
    vec1 = vec1 / norm(vec1);
    vec2 = vec2 / norm(vec2);    
    % Kinect to ground plane transformation
    T_gk = [vec1, vec2, cross(vec1,vec2)];
    
    % Change basis of Kinect point cloud
    kinectPoints(3,:) = double(depth(depth > 0));
    kinectPoints(2,:) = Y(depth > 0);
    kinectPoints(1,:) = X(depth > 0); 
    
    groundPoints = T_gk * kinectPoints;
    
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