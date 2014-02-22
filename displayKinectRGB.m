function displayKinectRGB(rgb, figNum)
% Displays RGB information captured from Kinect

    % Initialise FIGURE
    width = 640; 
    height = 480;
    % rgb image
    figure(figNum);
    h = imagesc(zeros(height,width,3,'uint8'));
    
    % Update figure 
    set(h,'CData',flipdim(rgb,2)); 
    drawnow;
end