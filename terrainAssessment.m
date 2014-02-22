function terrainAssessment
    addpath('./kinect/Mex');
    
    % Constants
    gridSize = 5;
    
    % Set up X,Y meshgrid for interpolation
    x = 0:639;  % pixels
    y = 0:479;  % pixels
    [X,Y] = meshgrid(x,y);
    
    context = createKinectContext(true);
    [rgb,depth] = getKinectData(context);
    displayKinectRGB(rgb,1);
    
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
    kinectPoints(3,:) = depth(:);
    kinectPoints(2,:) = Y(:);
    kinectPoints(1,:) = X(:);    
    kinectPoints = T_gk * kinectPoints;
    
    mxNiDeleteContext(context);
end