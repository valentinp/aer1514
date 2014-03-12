if exist('context')
    mxNiDeleteContext(context);
end
clear; close all;

[context,option] = createKinectContext(true);
[rgb,depth] = getKinectData(context,option);

terrain = terrainAssessment(context,option,1);
h = figure(100); h = imagesc(zeros(480,640,3,'uint8')); displayKinectRGB(rgb,h); hold on;
overlayTerrainGrid(h, terrain, context)

disp('position rover now and then press a key');
pause();
T_rg = localizeRover(context, option, terrain.T_gk);
 
roverLoc = homo2cart(T_rg \ [0;0;0;1]);
xStart = roverLoc(1); yStart = roverLoc(2);
xGoal = xStart-0.2; yGoal = yStart + 1.5;

waypoints = getPathSegments(xStart,yStart,xGoal,yGoal,terrain);

h = figure(101); h = imagesc(zeros(480,640,3,'uint8')); displayKinectRGB(rgb,h); hold on;
overlayPath(h,waypoints,terrain,context)