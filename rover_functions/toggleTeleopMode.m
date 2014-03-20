function toggleTeleopMode(wantTeleop)
    if wantTeleop
        set_param('robulink/teleop','Value','true');
    else
        set_param('robulink/teleop','Value','false');
    end
end