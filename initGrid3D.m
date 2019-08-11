function grid = initGrid3D(numRows, numCols, numPlanes, start, finish, threeDim)
% initGrid3D sets up a grid used for A* pathfinding with the specified number 
% of rows, columns, and (optionally) planes. Each node is initialized with:
%
% (1) node ID number
% (2) x, y, (optionally) z position. Uses either a square or hexagonal
% lattice. With or without random variation.
% (3) list of neighbors (nodes within some threshold distance)
% (4) g value (distance travelled from start node)
% (5) h value (distance to finish node)
% (6) f = g + h (the heuristic of the A* algorithm)
% (7) state: 0 = unvisited, 1 = visited (can be chosen as "current"), 
% -1 = closed (former "current" node, cannot be chosen again).
% (8) parent node (node responsible for the g value being updated) 
%
% There is an option to initialize a percentage of the nodes to the closed 
% state, making them "barriers" to the finish node.

numNodes = numRows*numCols*numPlanes;

% Initialize the grid structure
grid(1:numNodes) = struct('ID', [], 'pos', [], 'conn', [], ...
    'g', [], 'h', [], 'f', [], 'state', [], 'parent', []);

% Set the node separation in the x-, y-, and (optional) z-direction
dx = 1;
dy = 1;
dz = 1;

% Switch for hexagonal grid (0=square lattice, 1=hexagonal)
hexagonalGrid = 1;

% Set the maximum random variation, (-perturb, +perturb)
perturb = 0.2;

% Set the threshold for identifying neighbors
threshold = 1.3;

% Switch for random barriers (0=none, 1=barriers)
barriers = 1;
barrierFreq = 0.15; %change to alter barrier frequency

%initialize states
for i = 1:numNodes
   if i == start
      grid(i).state = 1;
   elseif i == finish
      grid(i).state = 0;
   else
       if barriers == true
           decider = rand;
           if decider <= barrierFreq
               grid(i).state = -1;
           else
               grid(i).state = 0;
           end
       else
           grid(i).state = 0;
       end
   end
end

% Set the ID and position
k = 1; j = 1; i = 1;
IDsFinished = false;
while ~IDsFinished
    % Construct a linear ID for ID
    linID = (k-1)*numRows + j + (i-1)*numRows*numCols;
    grid(linID).ID = linID;
    
    % Set the x, y, and (optional) z position
    grid(linID).pos(1) = k*dx + 2*perturb*(rand-0.5);
    grid(linID).pos(2) = j*dy + 2*perturb*(rand-0.5) + hexagonalGrid*mod(k, 2)/2;
    if threeDim == true
        grid(linID).pos(3) = i*dz + 2*perturb*(rand-0.5);
    end
    %increment iteration variables if needed
    j = j+1;
    if j > numRows
       j = 1;
       k = k+1;
    end
    if k > numCols && threeDim == true
       j = 1;
       k = 1;
       i = i+1;
    elseif k > numCols && threeDim == false
        IDsFinished = true;
    end
    if i > numPlanes
       IDsFinished = true; 
    end
end

%initialize h
for i = 1:numNodes
    ds = grid(i).pos - grid(finish).pos;
    grid(i).h = norm(ds);
end

%initialize g
for i = 1:numNodes
   if i == start
       grid(i).g = 0;
   else
       grid(i).g = Inf;
   end
end
%initialize f for start node
grid(start).f = grid(start).g + grid(start).h;

% Identify neighbors within threshold
for k = 1:numNodes    
    for j = 1:numNodes
        if k ~= j
            % Identify the neighbors of "k" from possibilities "j"
            dx = grid(k).pos - grid(j).pos;
            
            % The Euclidean norm of the [1x2] separation vector
            distance = norm(dx);
            
            % If j is close enough, add it as a neighbor of k
            if distance <= threshold
                grid(k).conn = [grid(k).conn, j];
            end
        end
    end
end

end