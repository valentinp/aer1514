function goto(xGoal, yGoal, varargin)
    axisToSensor = 0.08; % meters
    
    maxSpeed = 0.5;    % default
    if nargin > 2
        maxSpeed = varargin{1};
    end
    
    goalNorm = sqrt(xGoal^2 + yGoal^2);
    xGoal = xGoal - axisToSensor * xGoal / goalNorm;
    yGoal = yGoal - axisToSensor * yGoal / goalNorm;

    set_param('robulink/xGoal','Value',num2str(xGoal));
    set_param('robulink/yGoal','Value',num2str(yGoal));
    set_param('robulink/maxSpeed','Value',num2str(maxSpeed));
end