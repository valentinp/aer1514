%% Old path following code from simulink model

function [v, omega, phi, r, atGoal] = followStraightPath(xGoal, yGoal, k1, k2, maxSpeed)    
    global x;
    global y;
    global theta;
%     global atGoal;
   
    % constants
%     constVel = 0.5;
%     k1 = 5;
%     k2 = 1;
    
    % useful vectors
    p_fwd_i = [cosd(theta); sind(theta);0]; % forward direction
    p_ic_i = [x;y;0];           % vector from initial origin to current position
    p_ig_i = [xGoal;yGoal;0];   % vector from initial origin to goal position
    p_cg_i = p_ig_i - p_ic_i;   % vector from current position to goal position
    
    % safety first!
    v = 0;
    omega = 0;
    phi = 0;

    % stop if within 5 cm of goal
%     distToGoal = norm(p_cg_c);
%     if distToGoal > 0.01 %&& norm(p_ic_i) < 1.05 * norm(p_ig_i)
        
%         goalTheta = acosd(p_ig_i(1)/norm(p_ig_i));        
%         if p_ig_i(2) < 0
%             goalTheta = -goalTheta;
%         end

%         lateralErr = abs(x*endY - endX*y) / sqrt(endX*endX + endY*endY);

%         headingErr = theta - goalTheta;  
%         if headingErr > 180
%             headingErr = headingErr - 360;
%         elseif headingErr < -180
%             headingErr = headingErr + 360;
%         end

        % ASRL Pathtracker
        % Breaks if abs(headingErr) > 90
        % It will never turn around because of the sin term
        % i.e., it does not distinguish between forwards and backwards
        % directions
%         v = constVel;
%         omega = (-k1*lateralErr - k2*v*sind(headingErr))/(v*cosd(headingErr) + 1e-3);
         
%     else
%         lateralErr = 0;
%         headingErr = 0;
%     end

        % Lee et al., 2000
        r = norm(p_cg_i);
        
        atGoal = r <= 0.02;
        if ~atGoal
            phi = acosd(dot(p_fwd_i/norm(p_fwd_i), p_cg_i/norm(p_cg_i)));
            
            if phi < 45 || r > 0.08
                crossProd = cross(p_fwd_i,p_cg_i);
                if(crossProd(3) > 0)
                    phi = -phi;
                end

                v = k1 * r * cosd(phi);
                omega = -k1*sind(phi)*cosd(phi) - k2*phi;

                v = min(v,maxSpeed);
            else
                goalTheta = acosd(p_ig_i(1)/norm(p_ig_i));        
                if p_ig_i(2) < 0
                    goalTheta = -goalTheta;
                end
                
                if abs(theta - goalTheta) > 10
                    omega = -4 * sign(theta-goalTheta);
                end
            end
        end
end