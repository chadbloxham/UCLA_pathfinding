function [x, y, z, pathIDs, pathLen] = construct_path(grid, current, threeDim)
% construct_path finds the nodes associatted with the path currently begin
% considered by the A* algorithm. It creates x, y, and (possibly) z
% position arrays. It also calculates the length of the path as nodes are
% identified.

pathLen = 0;
%construct path
pathIDs = [grid(current).ID]; %current node is the end of the path
startReached = false;
while ~startReached
    %first element must become the parent of the previous first element
    child = pathIDs(1);
    parent = grid(child).parent;
    %add the parent to the beginning of the list unless the node has no
    %parent (it is the start node)
    if isempty(parent)
        startReached = true;
    else
        pathIDs = [parent, pathIDs];
        %update path length
        pathLen = pathLen + norm(grid(parent).pos - grid(child).pos);
    end
end
%get positions
x = [];
y = [];
for i = 1:length(pathIDs)
    x = [x, grid(pathIDs(i)).pos(1)];
    y = [y, grid(pathIDs(i)).pos(2)];
end
z = [];
if threeDim == true
    for i = 1:length(pathIDs)
        z = [z, grid(pathIDs(i)).pos(3)];
    end
end
end

