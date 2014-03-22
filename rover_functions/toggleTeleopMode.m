function toggleTeleopMode(enableTeleopMode)
    if enableTeleopMode
        set_param('robulink/teleop','Value','true');
    else
        set_param('robulink/teleop','Value','false');
    end
end