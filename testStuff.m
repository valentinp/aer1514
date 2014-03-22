if exist('context')
    mxNiDeleteContext(context);
end
clear; close all;

% Kinect image size
global width;   global height;
width = 640;    height = 480;

[context,option] = createKinectContext();
[rgb,depth] = getKinectData(context,option);
terrain = terrainAssessment(context,rgb,depth,1);

% disp('position rover now and then press a key');
% pause();

% % Test rover localization
% h = figure(102); h = imagesc(zeros(480,640,3,'uint8')); 
% while true
%     [rgb,depth] = getKinectData(context,option);
%     displayKinectRGB(rgb,h); hold on;
%     T_rg = localizeRover(context, rgb, depth, terrain.T_gk);
%     roverLoc = homo2cart(T_rg \ [0;0;0;1]);
%     roverLoc_k(1,1,:) = homo2cart(terrain.T_kg * cart2homo(roverLoc));
%     roverLoc_k_projective = mxNiConvertRealWorldToProjective(context, roverLoc_k);    
%     scatter(roverLoc_k_projective(1,1,1), roverLoc_k_projective(1,1,2)); drawnow;
% end

% [rgb,depth] = getKinectData(context,option);
T_rg = localizeRover(context,rgb,depth, terrain.T_gk);

terrain = markTerrainAroundRoverSafe(terrain,T_rg);

h = figure; h = imagesc(zeros(480,640,3,'uint8')); displayKinectRGB(rgb,h); hold on;
overlayTerrainGrid(h, terrain, context);

roverLoc = homo2cart(T_rg \ [0;0;0;1]);
xStart = roverLoc(1); yStart = roverLoc(2);
xGoal = xStart - 1; yGoal = yStart;

waypoints_g = getPathSegments(xStart,yStart,xGoal,yGoal,terrain);

[rgb,depth] = getKinectData(context,option);
h = figure(101); clf; h = imagesc(zeros(480,640,3,'uint8')); displayKinectRGB(rgb,h); hold on;

overlayPath(h,waypoints_g,terrain,context)