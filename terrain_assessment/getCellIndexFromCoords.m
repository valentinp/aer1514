function [i,j] = getCellIndexFromCoords(x,y,terrain)
    [~,i] = min(abs(terrain.cellMiddlesY - y));
    [~,j] = min(abs(terrain.cellMiddlesX - x));
end