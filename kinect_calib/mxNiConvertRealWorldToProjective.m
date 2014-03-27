function [depth] = mxNiConvertRealWorldToProjective( realWorld )
%MXNICONVERTPROJECTIVETOREALWORLD Summary of this function goes here
%   Detailed explanation goes here

%Camera intrinsics taken from ROS calibration of the IR camera

K = [594.701671 0.000000 325.334971;
0.000000 590.935950 233.867764;
0.000000 0.000000 1.000000;];

%D = [-0.059747 0.137327 -0.006317 0.001585 0.000000];
end
