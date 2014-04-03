addpath('utils');
load('map.mat');

% % Mission 1 Landmarks in world frame (rows)
landmarks_w = [-0.745, -2.558, 0.456;
                1.205, -2.213, 0.464;
                0.610, -3.619, 0.451];

% landmarks_w = [0,1,0; 5,1,0; 0,5,0]; % test case

% Store the points as column vectors
% NOTE: CHANGE THE ORDER
p1_w = landmarks_w(1,:)';   % Origin
p2_w = landmarks_w(2,:)';   % X-axis
p3_w = landmarks_w(3,:)';   % Y-axis

xAxis_w = normalize(p2_w - p1_w);
yAxis_w = normalize(p3_w - p1_w);
zAxis_w = cross(xAxis_w, yAxis_w);

R_mw = [xAxis_w, yAxis_w, zAxis_w]';
t_mw_w = p1_w;

T_mw = [R_mw, -R_mw*t_mw_w;
        0,0,0,1];
T_wm = inv(T_mw);

sampleList_w = homo2cart(T_wm * cart2homo(sampleList_m));
sampleList_w = sampleList_w(1:2,:)

csvwrite('nyquist-mission-1.txt',sampleList_w');