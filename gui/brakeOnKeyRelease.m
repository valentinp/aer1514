function brakeOnKeyRelease(src, event)
    global enableTeleopMode;
    
    if enableTeleopMode
        v = get_param('robulink/v','Value');
        omega = get_param('robulink/omega', 'Value');
        switch(event.Key)
            case 'leftarrow'
                omega = 0;
%                 disp('left arrow released')

            case 'rightarrow'
                omega = 0;
%                 disp('right arrow released')

            case 'uparrow'
                v = 0;
%                 disp('up arrow released')

            case 'downarrow'
                v = 0;
%                 disp('down arrow released')
        end
        drive(v,omega);
    end
end