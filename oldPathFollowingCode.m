%% Code from old simulink path following block

function [v, omega] = goToState(goalX, goalY, goalTheta)
    global x;
    global y;
    global theta;

    v = 0;
    omega = 0;
    
    % 25 degrees fudge factor because it consistently overshoots
    % by 25 for omega = 5
    fudgeFactor = 15;
    
    goalVector = [goalX - x; goalY - y];
    
    if norm(goalVector) > 0.05
        % Navigate to location
        
        goalHeading = acosd(goalVector(2)/goalVector(1));        
        if goalVector(2) < 0
            goalHeading = -goalHeading;
        end
   
%         if goalHeading - theta > fudgeFactor
%             omega = 4;
%             v = 0;
% %         elseif (goalHeading - theta) < -fudgeFactor
% %             omega = -4;
% %             v = 0;
%         else
%             omega = 0;
%             v = 0.5;
%         end      
%     else
%         % Rotate to desired final orientation
%         if (goalTheta - theta) > fudgeFactor
%             omega = 5;
%             v = 0;
%         elseif (goalTheta - theta) < -fudgeFactor
%             omega = -5;
%             v = 0;
%         else
%             omega = 0;
%             v = 0;
%         end

    

    end
end