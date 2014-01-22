% AER1514
% Valentin and Lee | Mr. Clementroukhin
% Occupancy Grid Attempt
% Map: 204 cm tall by 214cm wide, camera at each corner looking towards centroid
% Captures start at southeast corner and move clockwise

%% Initialize stuff
% Get RGB and DEPTH image via Kinect
clear
clc
addpath('./Mex');
addpath('../utils');


%Extract 4 depth file contexts
C{1} = load('occupancy_pose_1');
C{2} = load('occupancy_pose_2');
C{3} = load('occupancy_pose_3');
C{4} = load('occupancy_pose_4');


%Create a cell-grid
x = 0:2:(214 - 2);
y = 0:2:(204 - 2);
[X,Y] = meshgrid(x,y);

%Initialize the occupancy grid
occGrid = zeros(size(X));

maxDepth = 2040;

transform{1} = [C_1(45) -C_1(45)*[-2140 0 0]'; 0 0 0 1];
transform{2} = [C_1(-45) -C_1(-45)*[0 0 0]'; 0 0 0 1];
transform{3} = [C_1(-135) -C_1(-135)*[0 0 -2040]'; 0 0 0 1];
transform{4} = [C_2(0) -C_2(0)*[0 0 0]'; 0 0 0 1];

for i = 4
    %C{i}.depth(C{i}.depth> maxDepth) = maxDepth
    %align Depth onto RGB
%    real3D = cart2homo(squeeze(C{i}.real_XYZ(200,:,:))');
    
    real3D = C{i}.real_XYZ(:,:,:);
    real3D = reshape(real3D, size(real3D,1)*size(real3D,2), size(real3D,3))';
    real3D = cart2homo(real3D);
   %real3D = C_1(45)*real3D;
   real3D = homo2cart(real3D);
    
    
    real2D = real3D([1 3], :)';
    
    indicesToKeep = find(real2D(:,2) < maxDepth);
    
    real2D = real2D(indicesToKeep, :);
    
    h = hist3(real2D, [102 107]);
   
    occGrid = occGrid + 10*(h>0);
    occGrid = occGrid - ~h;
    break;
end
figure(1);
imagesc(occGrid); axis xy;