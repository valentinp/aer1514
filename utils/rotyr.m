function C = rotyr(theta)
% PURPOSE:      Generate 3x3 rotation matrix about the y-axis
%
% INPUT:        theta - rotation angle in radians
%
% OUTPUT:       C - 3x3 rotation matrix about the y-axis
%
% LAST EDIT:    Lee Clement, 2014-03-10

    c = cos(theta);
    s = sin(theta);
    
    C = [   c   0   s;
            0   1   0;
           -s   0   c   ];
end