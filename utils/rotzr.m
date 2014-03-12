function C = rotzr(theta)
% PURPOSE:      Generate 3x3 rotation matrix about the z-axis
%
% INPUT:        theta - rotation angle in radians
%
% OUTPUT:       C - 3x3 rotation matrix about the z-axis
%
% LAST EDIT:    Lee Clement, 2014-03-10

    c = cos(theta);
    s = sin(theta);
    
    C = [   c  -s   0;
            s   c   0;
            0   0   1   ];
end