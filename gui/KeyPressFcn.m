function KeyPressFcn(src, event)
    global enableTeleopMode;
    global v_teleop; global omega_teleop;
    
    if enableTeleopMode
        v = str2double(get_param('robulink/v','Value'));
        omega = str2double(get_param('robulink/omega', 'Value'));
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
    else
        switch(event.Key)
            case 'e'
                hammerheadGUI('btn_EmergStop_Callback');
        end
    end
    drawnow;
end