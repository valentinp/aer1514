function [C] = C_2(theta)
    C = [cosd(theta) 0 sind(theta); 
        0 1 0; 
        -sind(theta) 0 cosd(theta)];
end