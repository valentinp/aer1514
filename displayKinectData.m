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