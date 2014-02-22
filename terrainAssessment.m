function terrainAssessment
    % Constants
    gridSize = 5; 
    
    [rgb,depth] = getKinectData();
    displayKinectData(rgb,depth);
    
    % Select coordinates of 3 ground points
    [x,y] = ginput(3);
end