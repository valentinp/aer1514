function framePoints_k = selectFrame(context, rgb, depth)

global height;
global width;
% global terrain;

%Set up GUI
f = figure();
imgHandle = imshow(zeros(height,width,3,'uint8'));
hold on;

% [rgb,depth] = getKinectData(context);
displayKinectRGB(rgb,imgHandle); 
kinectPoints_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;

%  realWorldCoords = mxNiDepthRealWorld(context);
%  realWorldCoords=permute(realWorldCoords,[2 1 3]);
 

% disp('Select three points. (1) the origin (2) a point on the x-axis, (3) point on the y-axis.');  
% [x_frame,y_frame] = ginput(3);
% 
% mapFrame_k = zeros(3, 3);
% for i = 1:3
%     mapFrame_k(:,i) = reshape(realWorldCoords(round(y_frame(i)), round(x_frame(i)), :), [3,1]);  
%     mapFrame_k(1,i) = -mapFrame_k(1,i);
% end
% mapFrame_k = mapFrame_k/1000;
% 
% %Create the new frame
% t_mk_k = mapFrame_k(:,1);
% 
% vx = mapFrame_k(:,2) - mapFrame_k(:,1);
% vy = mapFrame_k(:,3) - mapFrame_k(:,1);
% 
% % Refine the frame by projecting onto the ground plane axes
% if isfield(terrain,'T_kg')
%     surfNorm = terrain.T_kg(1:3,3);
%     
%     vx = vx - (dot(vx,surfNorm) / (norm(surfNorm)^2)) * surfNorm;
%     vy = vy - (dot(vy,surfNorm) / (norm(surfNorm)^2)) * surfNorm;
% end
% 
% vz = cross(vx,vy);
% 
% vx = normalize(vx);
% vy = normalize(vy);  
% vz = normalize(vz);
% 
% R_mk = [vx,vy,vz]';  
% 
% % Plotting stuff
% realWorldPoints = zeros(1,3,3);
% for i=1:3
%     realWorldPoints(1,i,:) = mapFrame_k(:,i)*1000;
% end
% realWorldPoints(1,:,1) = -realWorldPoints(1,:,1);
% %realWorldPoints(1,:,:) = [mapFrame_k mapFrame_k(:,1)+vz];
% temp = mxNiConvertRealWorldToProjective(context, single(realWorldPoints));
% framePoints = zeros(2,3);
% for i=1:3
%     framePoints(:, i) = temp(1,i,1:2);
% end
% 
% %line(framePoints(1,1:2), framePoints(2,1:2), 'LineWidth',2,'Color','r');
% %line(framePoints(1,[1 3]), framePoints(2,[1 3]), 'LineWidth',2,'Color','g');
% 
% arrow(framePoints(:,1),framePoints(:,2), 'facecolor', 'r');
% arrow(framePoints(:,1),framePoints(:,3), 'facecolor', 'g');
% 
% 
% T_mk = [R_mk -R_mk*t_mk_k; 0 0 0 1];

disp('Select 3 world frame points and press enter');
[uWorld_k, vWorld_k] = ginput(3);

% Frame points are columns of this matrix
framePoints_k(:,3) = reshape(kinectPoints_k(round(vWorld_k(3)), round(uWorld_k(3)), :), [3,1]);
framePoints_k(:,2) = reshape(kinectPoints_k(round(vWorld_k(2)), round(uWorld_k(2)), :), [3,1]);
framePoints_k(:,1) = reshape(kinectPoints_k(round(vWorld_k(1)), round(uWorld_k(1)), :), [3,1]);

pause();
close(f);
end