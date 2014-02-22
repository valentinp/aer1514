function terrainAssessment
    % Constants
    gridSize = 5; 

    [rgb,depth] = getKinectData();
    displayKinectData(rgb,depth);
    
end