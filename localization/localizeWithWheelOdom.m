% function [ T_r2s ] = localizeWithWheelOdom(x,y,theta)
%     R_r2s = rotzd(theta);
%     t_r2s_s = [x y 0]';
%     T_r2s = [R_r2s -R_r2s*t_r2s_s; 0 0 0 1];
% end

function T_r2g = localizeWithWheelOdom(dx, dy, dtheta, T_r1g)
    if isnan(T_r1g)
        T_r2g = T_r1g;
        return;
    end
    R_r2r1 = rotzd(dtheta);
    t_r2r1_r1 = [dx; dy; 0];
    
    T_r2r1 = [R_r2r1 -R_r2r1 * t_r2r1_r1;
                    0 0 0 1];

     T_r2g = T_r2r1 * T_r1g;
end