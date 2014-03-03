function resetCoordFrame(newX, newY, newTheta)

    set_param('robulink/resetFlag','Value','1');
    set_param('robulink/newX','Value',num2str(newX));
    set_param('robulink/newY','Value',num2str(newY));
    set_param('robulink/newTheta','Value',num2str(newTheta));
    set_param('robulink/xGoal','Value',num2str(newX));
    set_param('robulink/yGoal','Value',num2str(newY));
    
    pause(0.2);
    set_param('robulink/resetFlag','Value','0');
end