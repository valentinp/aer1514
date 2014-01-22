function [C] = C_1(theta)
    C = [1 0 0; 
        0 cosd(theta) -sind(theta); 
        0 sind(theta) cosd(theta)];
end