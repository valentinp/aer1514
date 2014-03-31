function [ T_r2s ] = localizeWithWheelOdom(x,y,theta)
    R_r2s = rotzd(theta);
    t_r2s_s = [x y 0]';
    T_r2s = [R_r2s -R_r2s*t_r2s_s; 0 0 0 1];
end

