addpath('utils');
addpath('localization');

load('map.mat'); % Contains sampleList_k
load('worldpoints.mat'); % contains framePoints_k

% % Mission 1 Landmarks in world frame (rows)
framePoints_w = [-0.745, -2.558, 0.456;
                1.205, -2.213, 0.464;
                0.610, -3.619, 0.451]'; % <-- Note the transpose!

% framePoints_w = [0,1,0; 5,1,0; 0,5,0]'; % test case

T_wk = scalarWeightedPointCloudAlignment(framePoints_k, framePoints_w);
sampleList_w = T_wk * sampleList_k;

csvwrite('nyquist-mission-test.txt',sampleList_w');