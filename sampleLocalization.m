[context, option] = createKinectContext(true);
%Note: the w/h values must match the XML parameters read in the createKinectContext
%function above
width = 640; 
height = 480;
% Depth image
figure
subplot(1,2,1)
depthIm = imagesc(zeros(height,width,'uint16'));
title('Depth Image')
axis image;

% RGB image
subplot(1,2,2)
rgbIm = imshow(zeros(height,width,3,'uint8'));
title('RGB Image')
axis image;

global samplesTable;
global samplesList;
samplesList = [];
% Samples list
samplesTable = uitable('Position',[100 50 360 75]);



% Create some GUI buttons
btnClose = uicontrol('Style', 'PushButton', ...
                    'String', 'Close', ...
                    'Position', [350 5 120 20], ...
                    'Callback', 'delete(gcbf)');
btnPoints = uicontrol('Style', 'PushButton', ...
                    'String', 'Add Sample(s)', ...
                    'Position', [200 5 120 20], ...
                    'Callback', 'addSample(depth);');
btnClrPoints = uicontrol('Style', 'PushButton', ...
    'String', 'Clear Samples', ...
    'Position', [50 5 120 20], ...
    'Callback', 'samplesList = []; set(samplesTable, ''Data'', samplesList);');

 while (ishandle(depthIm))
    [rgb, depth] = getKinectData(context, option);
    set(rgbIm,'CData',rgb)
    set(depthIm,'CData',depth)
    pause(0.03);
end
mxNiDeleteContext(context);