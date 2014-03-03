function waypoints = getPathSegments(xStart, yStart, xGoal, yGoal, terrain)
% xStart, yStart, xGoal, yGoal, and waypoints in ground frame
addpath('utils'); % for dist function

    maxSlope = 15; % degrees
    maxIterations = 20; % path planning fails if no path found in this many iterations
       
    % Initialize cell states and costs for search
    cellStates = zeros(terrain.gridSize); % 0 = unvisited, 1 = dead, 2 = alive, 3 = ignore
    cellStates(terrain.planeMaxSlope > maxSlope) = 3; % ignore unsafe cells
    
    costToCome = Inf(terrain.gridSize);
    eucDist = Inf(terrain.gridSize);
    totalCost = Inf(terrain.gridSize);
    
    % Find out which cell we're currently in, and which cell we're trying
    % to get to
    cellMiddlesX = terrain.gridEdgesX(1:end-1) + 0.5*(terrain.gridEdgesX(2:end) - terrain.gridEdgesX(1:end-1));
    cellMiddlesY = terrain.gridEdgesY(1:end-1) + 0.5*(terrain.gridEdgesY(2:end) - terrain.gridEdgesY(1:end-1));
    [temp, iStart] = min(abs(cellMiddlesY - yStart));
    [temp, jStart] = min(abs(cellMiddlesX - xStart));
    [temp, iGoal] = min(abs(cellMiddlesY - yGoal));
    [temp, jGoal] = min(abs(cellMiddlesX - xGoal));
       
    % A* search  
    costToCome(iStart, jStart) = 0;
    eucDist(iStart, jStart) = dist([iStart,jStart],[iGoal,jGoal]);
    totalCost(iStart, jStart) = costToCome(iStart, jStart)+eucDist(iStart, jStart);
    cellStates(iStart, jStart) = 2; % 0 = unvisited, 1 = dead, 2 = alive
    visitedCells = [iStart, jStart, iStart, jStart]; % i, j, came from i, came from j
    
    q = [iStart, jStart, totalCost(iStart, jStart)];
    
    foundPath = false;
    
    while size(q,1) > 0
        iCurr = q(1,1);
        jCurr = q(1,2);
        q = q(2:end,:);
        
        % Add unvisited adjacent cells to the queue (including diagonal
        % paths) in clockwise order
        adjacentCells(:,2) = jCurr + [0 1 1 1 0 -1 -1 -1];
        adjacentCells(:,1) = iCurr + [1 1 0 -1 -1 -1 0 1];

        for n = 1:8
            iAdj = adjacentCells(n,1);
            jAdj = adjacentCells(n,2);

            if(iAdj >= 1 && iAdj <= terrain.gridSize(2)...
                    && jAdj >= 1 && jAdj <= terrain.gridSize(1))
                
                if cellStates(iAdj, jAdj) ~= 3

                    eucDist(iAdj, jAdj) = dist([iAdj,jAdj],[iGoal,jGoal]);

                    % Re-evaluate cost-to-come if we revisit a node
                    if(cellStates(iAdj, jAdj)) == 0
                        visitedCells(end+1,:) = [iAdj, jAdj, iCurr, jCurr];
                        costToCome(iAdj,jAdj) = costToCome(iCurr, jCurr)...
                                            + dist([iAdj,jAdj],[iCurr,jCurr]);
                    else
                        newCost = costToCome(iCurr, jCurr) + dist([iAdj,jAdj],[iCurr,jCurr]);
                        if newCost < costToCome(iAdj, jAdj)
                            costToCome(iAdj, jAdj) = newCost;
                            visitedCells(visitedCells(:,1) == iAdj & visitedCells(:,2) == jAdj, 3:4) = [iCurr, jCurr];
                        end
                    end

                    totalCost(iAdj, jAdj) = eucDist(iAdj, jAdj) + costToCome(iAdj, jAdj);

                    if(cellStates(iAdj, jAdj)) == 0
                        q(end+1,:) = [iAdj; jAdj; totalCost(iAdj, jAdj)];
                        cellStates(iAdj, jAdj) = 2;
                    end
                end
            end
        end
        
        % Mark current cell as dead
        cellStates(iCurr, jCurr) = 1;
        
        % Sort queue by cost
        q = sortrows(q,3);
        
        % Prune unneeded nodes once a path is found
        foundPath = foundPath || (iCurr == iGoal && jCurr == jGoal);
        if foundPath
            q = q( q(:,3) < totalCost(iGoal, jGoal) );
            cellStates(iGoal, jGoal) = 1;
        end
        
    end
    
    % Reconstruct the path backwards from the goal cell
    if foundPath
        disp('Pathfinding SUCCESS');    
        
        iCurr = iGoal; jCurr = jGoal;
        
        numWaypoints = 0;
        
        while ~(iCurr == iStart && jCurr == jStart)
            numWaypoints = numWaypoints + 1;
            waypoints_ij(numWaypoints,:) = [iCurr, jCurr];
            
            prevCell = visitedCells(visitedCells(:,1) == iCurr & visitedCells(:,2) == jCurr, 3:4);
            iCurr = prevCell(1);
            jCurr = prevCell(2);
        end
        
        % waypoints_ij are in reverse order, so flip them around when
        % converting to xy
        waypoints(1,:) = [xStart,yStart];
        for n = 1:numWaypoints - 1
            m = numWaypoints - n + 1;
            waypoints(n+1,:) = [cellMiddlesX(waypoints_ij(m,2)), cellMiddlesY(waypoints_ij(m,1))];
        end
        
        waypoints(n+2,:) = [xGoal, yGoal];
    else
        disp('Pathfinding FAILURE');
        waypoints = [];
    end
end