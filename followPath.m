function followPath(waypoints)
% This should be replaced by something better!
    waypoints = [0 1; 1 0] * waypoints';
    waypoints = waypoints';

    resetCoordFrame(0,0,0);
    
    for n = 2:size(waypoints,1)
        xGoal = waypoints(n,1) - waypoints(1,1);
        yGoal = waypoints(n,2) - waypoints(1,2);
        goto(xGoal,yGoal);
        pause(0.15);
    end
end