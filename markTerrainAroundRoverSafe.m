function terrain = markTerrainAroundRoverSafe(terrain, T_rg)
% Mark the 5x5 set of grid cells around the rover as safe
    roverLoc = homo2cart(T_rg \ [0;0;0;1]);    
    [i,j] = getCellIndexFromCoords(roverLoc(1),roverLoc(2),terrain);
    
    % Array index checks
    leftBound = max(i-2, 1);
    rightBound = min(i+2, terrain.gridSize(1));
    bottomBound = max(j-2, 1);
    topBound = min(j+2, terrain.gridSize(2));
    
    terrain.gridPlanesA(leftBound:rightBound, bottomBound:topBound) = 0;
    terrain.gridPlanesB(leftBound:rightBound, bottomBound:topBound) = 0;
    terrain.gridPlanesC(leftBound:rightBound, bottomBound:topBound) = 0;
    terrain.planeMaxSlope(leftBound:rightBound, bottomBound:topBound) = 0;
    terrain.safeCells(leftBound:rightBound, bottomBound:topBound) = true;
end