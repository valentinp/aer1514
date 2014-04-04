addpath('utils');
addpath('localization');

load('map.mat'); % Contains sampleList_k
load('worldpoints.mat'); % contains framePoints_k

% % Mission 1 Landmarks in world frame (rows)
framePoints_w = [-0.745, -2.558, 0.456;
                1.205, -2.213, 0.464;
                0.610, -3.619, 0.451]'; % <-- Note the transpose!

% framePoints_w = [0,1,0; 5,1,0; 0,5,0]'; % test case

framePoints_w = [   0.46, 0.3, 0;
                    -0.3, 0, 0;
                    0.3, -0.45, 0   ]'; % test case 2

[T_wk, error] = scalarWeightedPointCloudAlignment(framePoints_k, framePoints_w);
disp(['Mean transformation error: ' num2str(error)]);
sampleList_w = homo2cart(T_wk * cart2homo(sampleList_k));

csvwrite('nyquist-mission-test.txt',sampleList_w');