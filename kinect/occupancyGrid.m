% AER1514
% Valentin and Lee | Mr. Clementroukhin
% Occupancy Grid Attempt
function occupancyGrid(fileName)
    % Get RGB and DEPTH image via Kinect
    addpath('./Mex');
    %% Create context with xml file
    context = mxNiCreateContext('Config/SamplesConfig.xml');

    %% Initialise FIGURE
    width = 640; 
    height = 480;
    % depth image
    figure(1);
    h1 = imagesc(zeros(height,width,'uint16'));
    % rgb image
    figure(2);
    h2 = imagesc(zeros(height,width,3,'uint8'));

    %align Depth onto RGB
    option.adjust_view_point = true;
    % Acquire RGB and Depth image
    mxNiUpdateContext(context, option);
    [rgb, depth] = mxNiImage(context);
    % Update figure 
    set(h1,'CData',flipdim(depth,2)); 
    set(h2,'CData',flipdim(rgb,2)); 
    drawnow;

    %Change filename
    save(fileName)

    %% Delete the context object
    mxNiDeleteContext(context);
end

