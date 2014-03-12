function C = rotxr(theta)
% PURPOSE:      Generate 3x3 rotation matrix about the x-axis
%
% INPUT:        theta - rotation angle in radians
%
% OUTPUT:       C - 3x3 rotation matrix about the x-axis
%
% LAST EDIT:    Lee Clement, 2014-03-10

    c = cos(theta);
    s = sin(theta);
    
    C = [   1   0   0;
            0   c  -s;
            0   s   c   ];
end