function atGoal = followPath(context, option, waypoints_g, T_gk)
    addpath('utils'); figure(1010); clf; hold on;
        
    % Constants!
    v = 0.4;
    k1 = 1; % lateral
    k2 = 2; % heading
    goalThresh = 0.05; % meters
    pathLength = getPathLength(waypoints_g); % meters
    maxDistTraveled = 1.1*pathLength;
    distTraveled = 0;
    
    T_rg = localizeRover(context, option, T_gk);
    
    waypoints_g = [waypoints_g; zeros(1, size(waypoints_g,2))];
    waypoints_g = cart2homo(waypoints_g);
    waypoints_g(1:3,1) = waypoints_g(1:3,1) - 0.05*normalize(T_rg(1:3,4));
    
    scatter(waypoints_g(1,:),waypoints_g(2,:), 'xb'); axis equal; xlabel('x'); ylabel('y');
    
    atGoal = false;
    while ~atGoal && distTraveled <= maxDistTraveled
        T_rg_prev = T_rg;
        T_rg = localizeRover(context, option, T_gk);
        
        ds = norm(homo2cart(T_rg\[0;0;0;1]) - homo2cart(T_rg_prev\[0;0;0;1]));
        
        if ds < 0.1
%             currPos_k(1,1,:) = homo2cart(T_gk \ (T_rg \ [0;0;0;1]));
%             currPos_k_projective = mxNiConvertRealWorldToProjective(context,currPos_k*1000);
%             scatter(currPos_k_projective(1,1,1),currPos_k_projective(1,1,2),'og');
%             drawnow;

            currPos_g = homo2cart(T_rg\[0;0;0;1]);
            scatter(currPos_g(1),currPos_g(2),'or'); drawnow;
            
            distTraveled = distTraveled + ds;

            waypoints_r = homo2cart(T_rg * waypoints_g);    

            [w0Idx, w1Idx, w2Idx] = getClosestWaypointIndices(waypoints_r);
            w0_r = waypoints_r(:,w0Idx);
            w1_r = waypoints_r(:,w1Idx);

            R_rp = zeros(3,3);
            R_rp(:,1) = normalize(w1_r-w0_r);
            R_rp(:,2) = rotzd(-90)*R_rp(:,1);
            R_rp(:,3) = cross(R_rp(:,1), R_rp(:,2));
            R_pr = R_rp';

            t_pr_r = w0_r;

            T_pr = [R_pr, -R_pr * t_pr_r;
                    0,0,0,1];

            currPos_p = homo2cart(T_pr * [0;0;0;1]);
            lateralErr = currPos_p(2);        

            currSeg = w1_r - w0_r;
            currHeadingErr = getHeadingErr(currSeg);

            lambda = currPos_p(1)/norm(currSeg); % lambda is how far along in current path segment
            if(lambda < 0 || lambda > 1)
                brake;
                error(['Invalid lambda: ',num2str(lambda)]);
            end

            if w2Idx <= size(waypoints_r,2)
                w2_r = waypoints_r(:,w2Idx);

                nextSeg = w2_r - w1_r;
                nextHeadingErr = getHeadingErr(nextSeg);

                headingErr = (1-lambda)*currHeadingErr + lambda*nextHeadingErr;
            else
                headingErr = currHeadingErr;
            end

            omega = (-k1*lateralErr -k2*v*sin(headingErr))/(v*cos(headingErr));
            drive(v,omega);

            atGoal = norm(homo2cart(waypoints_g(:,end)) - homo2cart(T_rg\[0;0;0;1])) < goalThresh;
        end
    end
    brake();
end

function [w0Idx, w1Idx, w2Idx] = getClosestWaypointIndices(waypoints)
    dists = sqrt(sum(waypoints.^2,1));
    
    [~,closestIdx] = min(dists)
    nextIdx = closestIdx+1
    
    R_rs = zeros(3,3);
    R_rs(:,1) = normalize(waypoints(:,nextIdx) - waypoints(:,closestIdx));
    R_rs(:,2) = rotzd(90)*R_rs(:,1);
    R_rs(:,3) = cross(R_rs(:,1),R_rs(:,2));
    R_sr = R_rs';
    
    t_sr_r = [waypoints(:,closestIdx)];
    
    T_sr = [R_sr, -R_sr*t_sr_r;
                0,0,0,1];
    
    currPos_s = homo2cart(T_sr * [0;0;0;1])
    
    if currPos_s(1) > 0
        w0Idx = closestIdx;
        w1Idx = closestIdx + 1;
        w2Idx = closestIdx + 2;
    else
        w0Idx = closestIdx - 1;
        w1Idx = closestIdx;
        w2Idx = closestIdx + 1;
    end
            
%     if(closestIdx == 1)
%         w0Idx = closestIdx;
%         w1Idx = closestIdx + 1;
%         w2Idx = closestIdx + 2;
%     elseif(closestIdx == size(waypoints,2))
%         w0Idx = closestIdx - 1;
%         w1Idx = closestIdx;
%         w2Idx = NaN;
%     elseif(closestIdx == size(waypoints,2)-1)
%         if(dists(nextIdx) < dists(prevIdx))
%             w0Idx = closestIdx;
%             w1Idx = closestIdx + 1;
%             w2Idx = NaN;
%         else
%             w0Idx = closestIdx - 1;
%             w1Idx = closestIdx;
%             w2Idx = closestIdx + 1;
%         end
%     else
%         if(dists(nextIdx) < dists(prevIdx))
%             w0Idx = closestIdx;
%             w1Idx = closestIdx + 1;
%             w2Idx = closestIdx + 2;
%         else
%             w0Idx = closestIdx - 1;
%             w1Idx = closestIdx;
%             w2Idx = closestIdx + 1;
%         end
%     end
end

function pathLength = getPathLength(waypoints)
    pathVecs = waypoints(:,2:end) - waypoints(:,1:end-1);
    pathDists = sqrt(sum(pathVecs.^2,1));
    pathLength = sum(pathDists);
end

function headingErr = getHeadingErr(segment)
    fwdDir = [1;0;0];
    headingErr = acos(dot(segment,fwdDir)/norm(segment));
    
    signCheck = cross(fwdDir, segment);
    if signCheck(3) < 0
        headingErr = -headingErr;
    end    
end

% function followPathOld(context, option, waypoints, T_rg, T_gk)  
%     addpath('utils');
%     
%     waypoints = [waypoints, zeros(size(waypoints,1),1)];
%     waypoints = homo2cart(T_rg * cart2homo(waypoints'));
%     waypoints = waypoints';
% 
%     resetCoordFrame(0,0,0);
%     
%     atGoal = false;
%     for n = 2:size(waypoints,1)
%         while ~atGoal
%             rto = get_param('robulink/Path Following','RunTimeObject');
%             atGoal = rto.OutputPort(5).Data;
%         end
% %         roverLoc = localizeRover(context, option, terrain.T_gk);
% %         resetCoordFrame(roverLoc(1),roverLoc(2));
%         xGoal = waypoints(n,1) - waypoints(1,1);
%         yGoal = waypoints(n,2) - waypoints(1,2);
%         goto(xGoal,yGoal);
%     end
% end