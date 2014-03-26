function T_mk = selectFrame(context)

global height;
global width;

%Set up GUI
f = figure();
imgHandle = imshow(zeros(height,width,3,'uint8'));
hold on;

[rgb,depth] = getKinectData(context);
displayKinectRGB(rgb,imgHandle); 
realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);

%  realWorldCoords = mxNiDepthRealWorld(context);
%  realWorldCoords=permute(realWorldCoords,[2 1 3]);
 

disp('Select three points. (1) the origin (2) a point on the x-axis, (3) point on the y-axis.');  
[x_frame,y_frame] = ginput(3);

mapFrame_k = zeros(3, 3);
for i = 1:3
    mapFrame_k(:,i) = reshape(realWorldCoords(round(y_frame(i)), round(x_frame(i)), :), [3,1]);  
    mapFrame_k(1,i) = -mapFrame_k(1,i);
end
mapFrame_k = mapFrame_k/1000;

%Create the new frame
t_mk_k = mapFrame_k(:,1);

vx = mapFrame_k(:,2) - mapFrame_k(:,1);
vx = normalize(vx);
vy = mapFrame_k(:,3) - mapFrame_k(:,1);
vy = normalize(vy);
vz = cross(vx,vy);
vz = normalize(vz);
R_mk = [vx,vy,vz]';    

realWorldPoints = zeros(1,3,3);
for i=1:3
    realWorldPoints(1,i,:) = mapFrame_k(:,i)*1000;
end
realWorldPoints(1,:,1) = -realWorldPoints(1,:,1);
%realWorldPoints(1,:,:) = [mapFrame_k mapFrame_k(:,1)+vz];
temp = mxNiConvertRealWorldToProjective(context, single(realWorldPoints));
framePoints = zeros(2,3);
for i=1:3
    framePoints(:, i) = temp(1,i,1:2);
end

%line(framePoints(1,1:2), framePoints(2,1:2), 'LineWidth',2,'Color','r');
%line(framePoints(1,[1 3]), framePoints(2,[1 3]), 'LineWidth',2,'Color','g');

arrow(framePoints(:,1),framePoints(:,2), 'facecolor', 'r');
arrow(framePoints(:,1),framePoints(:,3), 'facecolor', 'g');


T_mk = [R_mk -R_mk*t_mk_k; 0 0 0 1];

pause();
close(f);
end