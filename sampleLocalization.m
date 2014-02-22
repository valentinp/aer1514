[context, option] = createKinectContext(true);
%Note: the w/h values must match the XML parameters read in the createKinectContext
%function above
width = 640; 
height = 480;
% Depth image
figure
subplot(1,2,1)
title('Depth Image')
depthIm = imagesc(zeros(height,width,'uint16'));
axis image;

% RGB image
subplot(1,2,2)
title('RGB Image')
rgbIm = imshow(zeros(height,width,3,'uint8'));
axis image;

% Create a little button to break the loop
H = uicontrol('Style', 'PushButton', ...
                    'String', 'Break', ...
                    'Callback', 'delete(gcbf)');
while (ishandle(depthIm))
    [rgb, depth] = getKinectData(context, option);
    set(rgbIm,'CData',rgb)
    set(depthIm,'CData',depth)
    pause(0.03);
end
mxNiDeleteContext(context);