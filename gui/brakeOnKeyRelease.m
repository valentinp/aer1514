function brakeOnKeyRelease(src, event)
    global enableTeleopMode;
    if enableTeleopMode
        switch(event.Key)
            case 'leftarrow'
                brake;
    %             disp('left arrow released')

            case 'rightarrow'
                brake;
    %             disp('right arrow released')

            case 'uparrow'
                brake;
    %             disp('up arrow released')

            case 'downarrow'
                brake;
    %             disp('down arrow released')
        end
    end
end