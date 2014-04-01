% function [ T_r2s ] = localizeWithWheelOdom(x,y,theta)
%     R_r2s = rotzd(theta);
%     t_r2s_s = [x y 0]';
%     T_r2s = [R_r2s -R_r2s*t_r2s_s; 0 0 0 1];
% end

function T_r2g = localizeWithWheelOdom(xDot, yDot, thetaDot, T_r1g, timestep)
    if isnan(T_r1g)
        T_r2g = T_r1g;
        return;
    end
    R_r2r1 = rotzd(timestep * thetaDot);
    t_r2r1_r1 = timestep * [xDot; yDot; 0];
    
    T_r2r1 = [R_r2r1 -R_r2r1 * t_r2r1_r1;
                    0 0 0 1];

     T_r2g = T_r2r1 * T_r1g;
end