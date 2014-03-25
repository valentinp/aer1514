function T_mk = selectFrame(context)

global height;
global width;

%Set up GUI
f = figure();
imgHandle = imshow(zeros(height,width,3,'uint8'));

[rgb,depth] = getKinectData(context);
displayKinectRGB(rgb,imgHandle); 
realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);
 
disp('Select three points. (1) the origin (2) a point on the x-axis, (3) point on the y-axis.');  
[x_frame,y_frame] = ginput(3);

mapFrame_k = zeros(3, 3);
for i = 1:3
    mapFrame_k(:,i) = reshape(realWorldCoords(round(y_frame(i)), round(x_frame(i)), :), [3,1]);  
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

T_mk = [R_mk -R_mk*t_mk_k; 0 0 0 1];

close(f);
end