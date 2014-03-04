function [i,j] = getCellIndexFromCoords(x,y,terrain)
    [temp,i] = min(abs(terrain.cellMiddlesY - y));
    [temp,j] = min(abs(terrain.cellMiddlesX - x));
end