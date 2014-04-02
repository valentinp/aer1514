function [waypoints, pathLength] = getPathSegments(h, xStart, yStart, xGoal, yGoal, terrain)
% xStart, yStart, xGoal, yGoal, and waypoints in ground frame

    % Initialize cell states
    cellStates = zeros(terrain.gridSize); % 0 = unvisited, 1 = dead, 2 = alive, 3 = ignore    
    cellStates(~terrain.safeCells) = 3;   % Ignore unsafe cells
    
    % Find out which cell we're currently in, and which cell we're trying
    % to get to
    [iStart, jStart] = getCellIndexFromCoords(xStart,yStart,terrain);
    [iGoal, jGoal] = getCellIndexFromCoords(xGoal,yGoal,terrain);     
    
    % No point path planning at all if start and end points are invalid
    if terrain.safeCells(iStart,jStart) && terrain.safeCells(iGoal,jGoal)
        
        % First, see if we can just drive in a straight line to the goal
        straightPathVec = [xGoal - xStart; yGoal - yStart];
        straightPathLength = norm(straightPathVec);
        straightPathNumPoints = ceil(straightPathLength / 0.05);
        straightPathPoints = repmat([xStart;yStart], [1,straightPathNumPoints]) ...
            + repmat(linspace(0,straightPathLength,straightPathNumPoints), [2,1]) ...
            .* repmat(0.05*normalize(straightPathVec), [1,straightPathNumPoints]);

        % Check if all the cells we intersect are safe
        n = 1;
        foundPath = true;
        while n <= straightPathNumPoints && foundPath
            [iPoint, jPoint] = getCellIndexFromCoords(straightPathPoints(1,n), straightPathPoints(2,n), terrain);
            foundPath = foundPath && terrain.safeCells(iPoint, jPoint);
            n = n+1;
        end

        % If there were no obstacles, return start and goal as the only
        % waypoints
        if foundPath
            waypoints = [xStart, xGoal; yStart; yGoal];            
        else            
        % Fall back to A* search if there isn't a straight line path
        
            % Initialize costs and cell states
            costToCome = Inf(terrain.gridSize);
            eucDist = Inf(terrain.gridSize);
            totalCost = Inf(terrain.gridSize);
        
            costToCome(iStart, jStart) = 0;
            eucDist(iStart, jStart) = dist([iStart,jStart],[iGoal,jGoal]);
            totalCost(iStart, jStart) = costToCome(iStart, jStart)+eucDist(iStart, jStart);
            cellStates(iStart, jStart) = 2; % 0 = unvisited, 1 = dead, 2 = alive
            visitedCells = [iStart, jStart, iStart, jStart]; % i, j, came from i, came from j

            q = [iStart, jStart, totalCost(iStart, jStart)];

    %         foundPath = false;

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
                end % for neighbours

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
            end % while     

            % Reconstruct the path backwards from the goal cell
            if foundPath
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
                % converting to xy (also make them column vectors)
                waypoints(:,1) = [xStart;yStart];
                for n = 1:numWaypoints - 1
                    m = numWaypoints - n + 1;
                    waypoints(:,n+1) = [terrain.cellMiddlesX(waypoints_ij(m,2)); terrain.cellMiddlesY(waypoints_ij(m,1))];
                end

                waypoints(:, n+2) = [xGoal; yGoal];

                for n = 1:numWaypoints
                    cellStates(waypoints_ij(n,1),waypoints_ij(n,2)) = 4;
                end
            end % path reconstruction
        end % A*
    end % if start and goal safe
    
    % Display stuff
    if foundPath
        disp('Pathfinding SUCCESS');
        pathLength = getPathLength(waypoints);
    else
        disp('Pathfinding FAILURE');
        waypoints = [];
        pathLength = 0;
    end
    
    cellStates(iStart,jStart) = -5;
    cellStates(iGoal,jGoal) = 5;
    imagesc(cellStates, 'Parent', h)
    set(h, 'XTick',[],'YTick',[],'XDir','Normal','YDir','Normal');
    
    % Cut out unneeded waypoints
    if ~isempty(waypoints)
        waypoints = simplifyPath(waypoints);
    end
end

function pathLength = getPathLength(waypoints)
    pathVecs = waypoints(:,2:end) - waypoints(:,1:end-1);
    pathDists = sqrt(sum(pathVecs.^2,1));
    pathLength = sum(pathDists);
end