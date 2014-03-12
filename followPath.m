function followPath(context, option, waypoints, T_rg, T_gk)  
    addpath('utils');
    
    waypoints = [waypoints, zeros(size(waypoints,1),1)];
    waypoints = homo2cart(T_rg * cart2homo(waypoints'));
    waypoints = waypoints';

    resetCoordFrame(0,0,0);
    
    atGoal = false;
    for n = 2:size(waypoints,1)
        while ~atGoal
            rto = get_param('robulink/Path Following','RunTimeObject');
            atGoal = rto.OutputPort(5).Data;
        end
%         roverLoc = localizeRover(context, option, terrain.T_gk);
%         resetCoordFrame(roverLoc(1),roverLoc(2));
        xGoal = waypoints(n,1) - waypoints(1,1);
        yGoal = waypoints(n,2) - waypoints(1,2);
        goto(xGoal,yGoal);
    end
end