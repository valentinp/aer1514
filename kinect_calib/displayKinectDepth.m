function displayKinectDepth(depth, figHandle)
% Displays depth information captured from Kinect

    % Initialise FIGURE
%     width = 640; 
%     height = 480;
%     % depth image
%     figure(figNum);
%     h = imagesc(zeros(height,width,'uint16'));
    
    % Update figure 
    set(figHandle,'CData',depth); 
    drawnow;
end