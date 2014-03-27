function driveOnKeyPress(src, event)
    global enableTeleopMode;
    global v_teleop; global omega_teleop;
    
    if enableTeleopMode
        v = get_param('robulink/v','Value');
        omega = get_param('robulink/omega', 'Value');
        switch(event.Key)
            case 'leftarrow'
                omega = omega_teleop;
%                 disp('left arrow pressed')

            case 'rightarrow'
                omega = -omega_teleop;
%                 disp('right arrow pressed')

            case 'uparrow'
                v = v_teleop;
%                 disp('up arrow pressed')

            case 'downarrow'
                v = -v_teleop;
%                 disp('down arrow pressed')
        end
        drive(v,omega)
    end
end