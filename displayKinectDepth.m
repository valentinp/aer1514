function displayKinectDepth(depth, figNum)
% Displays depth information captured from Kinect

    % Initialise FIGURE
    width = 640; 
    height = 480;
    % depth image
    figure(figNum);
    h = imagesc(zeros(height,width,'uint16'));
    
    % Update figure 
    set(h,'CData',flipdim(depth,2)); 
    drawnow;
end