function displayKinectRGB(rgb, figHandle)
% Displays RGB information captured from Kinect

    % Initialise FIGURE
    % rgb image
    % figure(figNum);
    % h = imagesc(zeros(height,width,3,'uint8'));
    
    % Update figure 
    set(figHandle,'CData',flipdim(rgb,2)); 
    drawnow;
end