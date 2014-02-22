function goto(goalX, goalY, varargin)
    axisToSensor = 0.08; % meters
    
    maxSpeed = 0.5;    % default
    if nargin > 2
        maxSpeed = varargin{1};
    end
    
    goalNorm = sqrt(goalX^2 + goalY^2);
    goalX = goalX - axisToSensor * goalX / goalNorm;
    goalY = goalY - axisToSensor * goalY / goalNorm;

    set_param('robulink/endX','Value',num2str(goalX));
    set_param('robulink/endY','Value',num2str(goalY));
    set_param('robulink/maxSpeed','Value',num2str(maxSpeed));
end