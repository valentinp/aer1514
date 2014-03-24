function [atGoal, distTraveled] = followPathIteration(T_rg, T_rg_prev, waypoints_g, distTraveled)
    
    % Check that we can localize
    if isnan(T_rg)
        disp('Could not localize rover! Driving blind and trying again...');
        drive(0.5*v, 0);
        
    else
        ds = norm(homo2cart(T_rg\[0;0;0;1]) - homo2cart(T_rg_prev\[0;0;0;1]));

        if ds < 0.1
            currPos_g = homo2cart(T_rg\[0;0;0;1]);

            distTraveled = distTraveled + ds;

            waypoints_r = homo2cart(T_rg * waypoints_g);    

            [w0Idx, w1Idx, w2Idx] = getClosestWaypointIndices(waypoints_r);

            if (w0Idx == 0)
                drive(v*0.5,0);
                disp('WARNING: Start rover position is behind the current path');
                
            else
                T_pr = getPathTransformation(waypoints_r, w0Idx, w1Idx);
                currPos_p = homo2cart(T_pr * [0;0;0;1]);
                lateralErr = -1*currPos_p(2);
                currSeg = waypoints_r(:,w1Idx) - waypoints_r(:,w0Idx);

                lambda = currPos_p(1)/norm(currSeg); % lambda is how far along in current path segment
                if(lambda < -0.05 || lambda > 1)
                    %brake;
                    %error(['Invalid lambda: ',num2str(lambda)]);
                    disp(['Warning: Lambda value out of range: ' num2str(lambda)])
                end

                if lambda > 1                
                    if w2Idx > size(waypoints_r,2)
                        disp('Already on final path segment. Stopping.');
                        atGoal = true;
                    else
                        disp('Switching to next path segment');
                        w0Idx = w0Idx + 1;
                        w1Idx = w1Idx + 1;
                        w2Idx = w2Idx + 1;

                        T_pr = getPathTransformation(waypoints_r, w0Idx, w1Idx);
                        currSeg = waypoints_r(:,w1Idx) - waypoints_r(:,w0Idx);
                        currPos_p = homo2cart(T_pr * [0;0;0;1]);
                        lateralErr = -1*currPos_p(2);   
                    end                
                end

                currHeadingErr = getHeadingErr(currSeg);

                if w2Idx <= size(waypoints_r,2)

                    nextSeg = waypoints_r(:,w2Idx) - waypoints_r(:,w1Idx);
                    nextHeadingErr = getHeadingErr(nextSeg);

                    headingErr = (1-lambda)*currHeadingErr + lambda*nextHeadingErr;
                else
                    headingErr = currHeadingErr;
                end

                omega = (-k1*lateralErr -k2*v*sin(headingErr))/(v*cos(headingErr));
                drive(v,omega);
                disp(['Heading Error: ' num2str(headingErr*180/pi)])
                disp(['Omega: ' num2str(omega)]);
                disp(['Lateral Error: ' num2str(lateralErr)]);

                % " atGoal || " handles the case when atGoal is set to true
                % when lambda > 1 and we're at the end of the path
                atGoal = atGoal || norm(homo2cart(waypoints_g(:,end)) - homo2cart(T_rg\[0;0;0;1])) < goalThresh;
            end
        end
    end
end

function [w0Idx, w1Idx, w2Idx] = getClosestWaypointIndices(waypoints_r)
    dists = sqrt(sum(waypoints_r.^2,1));
    
    [~,closestIdx] = min(dists);
    nextIdx = closestIdx+1;
    
    %Check if we are closest to the last waypoint
    if closestIdx == size(waypoints_r, 2)
        w0Idx = closestIdx - 1;
        w1Idx = closestIdx;
        w2Idx = closestIdx + 1;
        return;
    end
    
    R_rs = zeros(3,3);
    R_rs(:,1) = normalize(waypoints_r(:,nextIdx) - waypoints_r(:,closestIdx));
    R_rs(:,2) = rotzd(90)*R_rs(:,1);
    R_rs(:,3) = cross(R_rs(:,1),R_rs(:,2));
    R_sr = R_rs';
    
    t_sr_r = waypoints_r(:,closestIdx);
    
    T_sr = [R_sr, -R_sr*t_sr_r;
                0,0,0,1];
    
    currPos_s = homo2cart(T_sr * [0;0;0;1]);
    
    if currPos_s(1) > 0
        w0Idx = closestIdx;
        w1Idx = closestIdx + 1;
        w2Idx = closestIdx + 2;
    else
        w0Idx = closestIdx - 1;
        w1Idx = closestIdx;
        w2Idx = closestIdx + 1;
    end
           
end

function headingErr = getHeadingErr(segment)
    fwdDir = [1;0;0];
    headingErr = acos(dot(segment,fwdDir)/norm(segment));
    
    signCheck = cross(fwdDir, segment);
    if signCheck(3) > 0
        headingErr = -headingErr;
    end    
end

function T_pr = getPathTransformation(waypoints_r, w0Idx, w1Idx)
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
end