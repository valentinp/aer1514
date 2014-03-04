function followPath(waypoints)  
    % This transform won't be correct in general. Need T_rg
    waypoints = [0 1; 1 0] * waypoints';
    waypoints = waypoints';

    resetCoordFrame(0,0,0);
    
    atGoal = false;
    for n = 2:size(waypoints,1)
        while ~atGoal
            rto = get_param('robulink/Path Following','RunTimeObject');
            atGoal = rto.OutputPort(5).Data;
        end
        xGoal = waypoints(n,1) - waypoints(1,1);
        yGoal = waypoints(n,2) - waypoints(1,2);
        goto(xGoal,yGoal);
    end
end