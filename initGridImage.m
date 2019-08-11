function grid = initGridImage(rgb)
% Creates a grid for A* traversal much like initGrid3D(). However, finds
% nodes by isolating pixels of specific rgb values (gray roads on the map).
% The start and finish nodes are found outside of this function using
% starting and finishing pixel positions inputted by the user.

%define constants
dim = size(rgb);
numRows = dim(1);
numCols = dim(2);

%because the number of pixels is large, we want to set a minimum distance
%between the nodes that are added to our grid so that we don't have to
%include every pixel with the correct rgb values
minDist = 50;
%we also must define a the maximum distance two nodes can be separated to
%be considered "connected" (must be greater than the minimum separation)
threshold = 100;

% Initialize the grid structure
grid = struct('ID', [], 'pos', [], 'conn', [], 'g', [], 'h', [], 'f', [], ...
    'state', [], 'parent', []);

% Set the ID, position, and state. We will add nodes based on rgb value
% range of our choosing. For the map of UCLA, we want the roads (which are grey) 
% to be the only nodes in the grid. This corresponds to a range approximately 
% between 100 and 140 for each color. Each rgb value is an 8 bit integer 
% between 0 and 255
linID = 0;
% dStart = [];
% dFinish = [];
for k = 1:5:numCols %minimum road width is 5 pixels, so no roads will be skipped
    for j = 1:5:numRows
        if rgb(j,k,1)>=115 && rgb(j,k,1)<=125 && rgb(j,k,2)>=115 && rgb(j,k,2)<=125 ...
              && rgb(j,k,3)>=115 && rgb(j,k,3)<=125 %test if it's a road
          if isempty([grid.ID]) %first pixel to pass the rgb condition is added
              linID = linID+1;
              grid(linID).ID = linID;
              grid(linID).state = 0;
              grid(linID).pos = [k,j];
          else   
              %all other nodes must satisfy our minimum separation condition
              farEnough = true;
              i = 1;
              while farEnough && i <= length([grid.ID])
                  ds = [k,j] - grid(i).pos;
                  if norm(ds) <= minDist
                      farEnough = false;
                  end
                  i=i+1;
              end
              %if it does satisfy this condition, add its ID, state, and
              %position
              if farEnough
                  linID = linID+1;
                  grid(linID).ID = linID;
                  grid(linID).state = 0;
                  grid(linID).pos = [k,j];
              end
          end
        end
    end
end
numNodes = length([grid.ID]);
%find neighbors of each node
for i = 1:numNodes
    for j = 1:numNodes
        if i ~= j
            ds = grid(i).pos - grid(j).pos;
            if norm(ds) <= threshold
                grid(i).conn = [grid(i).conn, j];
            end
        end
    end
end

end