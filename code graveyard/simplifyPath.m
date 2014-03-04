function waypointsNew = simplifyPath(waypointsOld)
% Attempt to smooth out the path following by condensing straight path
% segments to two points
% i.e.      *  *  *  *  *
% becomes   *           *

    minDirChange = 10; % degrees

    waypointsNew(1,:) = waypointsOld(1,:);
    
    currSegmentDir = waypointsOld(2,:) - waypointsOld(1,:);
    for n = 2:size(waypointsOld,1)
        nextSegmentDir = waypointsOld(n,:) - waypointsOld(n-1,:);
        
        dirChange = real(acosd(dot(currSegmentDir,nextSegmentDir)/(norm(currSegmentDir)*norm(nextSegmentDir)))); % small Im component near acosd(1)
        if dirChange > minDirChange
            waypointsNew(end+1,:) = waypointsOld(n-1,:);
            currSegmentDir = nextSegmentDir;
        end        
    end
    
    waypointsNew(end+1,:) = waypointsOld(end,:);
end