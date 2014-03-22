function driveOnKeyPress(src, event)
    global enableTeleopMode;
    if enableTeleopMode
        switch(event.Key)
            case 'leftarrow'
                drive(0,-4);
    %             disp('left arrow pressed')

            case 'rightarrow'
                drive(0,4);
    %             disp('right arrow pressed')

            case 'uparrow'
                drive(0.4,0);
    %             disp('up arrow pressed')

            case 'downarrow'
                drive(-0.4,0);
    %             disp('down arrow pressed')
        end
    end
end