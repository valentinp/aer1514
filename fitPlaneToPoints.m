function [a,b,c] = fitPlaneToPoints(x,y,z)
% a + bx + cy = z

    A(:,3) = y(:);
    A(:,2) = x(:);
    A(:,1) = ones(size(x,1),1);
    
    x = A \ z(:); % auto least squares!
    
    a = x(1);
    b = x(2);
    c = x(3);
end