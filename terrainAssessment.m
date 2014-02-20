function terrainAssessment
    % Constants
    gridSize = 5; 

    [rgb,depth] = getKinectData();
    displayKinectData(rgb,depth);
    
end

function [rgb, depth] = getKinectData
% Captures rgb and depth data from Kinect camera

    addpath('./kinect/Mex');
    
    % Create context with xml file
    context = mxNiCreateContext('./kinect/Config/SamplesConfig.xml');
    
    % Align Depth onto RGB
    option.adjust_view_point = true;
    % Acquire RGB and Depth image
    mxNiUpdateContext(context, option);
    [rgb, depth] = mxNiImage(context);
    
    % Delete the context object
    mxNiDeleteContext(context);
end

function displayKinectData(rgb,depth)
% Displays RGB and depth information captured from Kinect

    % Initialise FIGURE
    width = 640; 
    height = 480;
    % depth image
    figure(1);
    h1 = imagesc(zeros(height,width,'uint16'));
    % rgb image
    figure(2);
    h2 = imagesc(zeros(height,width,3,'uint8'));
    
    % Update figure 
    set(h1,'CData',flipdim(depth,2)); 
    set(h2,'CData',flipdim(rgb,2)); 
    drawnow;
end