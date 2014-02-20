function resetCoordFrame
    set_param('robulink/resetFlag','Value','1');
    set_param('robulink/endX','Value','0');
    set_param('robulink/endY','Value','0');
    
    pause(0.2);
    set_param('robulink/resetFlag','Value','0');
end