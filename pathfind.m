function [grid, current, nodesOpen] = pathfind(grid, current)
% pathfind uses the grid created by initGrid3D or initGridImage to find a
% path between the start and finish node. This path is found using the A*
% algorithm. See the notes in initGrid3D for info on the properties of each node.
% 
% The algorithm repeatedly selects the node with the smallest f
% value as the "current" node and updates the f values of each neighbor if
%
%                    g_curr + d(curr,neigh) < g_neigh
%
% i.e. the length of the path which goes through the current node is less
% than the existing g value (length of some other path). Because all
% non-start nodes have an initial g value of infinity, this update will
% always occur the first time a node is encountered as one of the neighbors
% of the current node.
% 
% The state of each neighbor is changed to 1 (if not already). This makes the 
% neighbor nodes eligible to be chosen as the next current node. The state
% of the current node is changed to -1. This makes the node ineligible to
% be chosen as the current node once again. If the new current node is the
% finish node, A* has successfully found the shortest path from start to
% finish. If there are no nodes with state == 1, no path exists between
% start and finish. There may still be nodes which are unvisited, but they
% are blocked by "barrier nodes" (initialized to state == -1) which cannot
% participate in the A* process.

nodesOpen = true;
%identify non-closed neighbors
neighbors = grid(current).conn;
for i = 1:length(neighbors)
    thisNeigh = neighbors(i);
    neighState = grid(thisNeigh).state;
    if neighState ~= -1
        %if state is 0 change it to 1
        if neighState == 0
            grid(thisNeigh).state = 1;
        end
        %calculate and store new f, g, and parent values (if needed)
        ds = grid(current).pos - grid(thisNeigh).pos;
        gNew = grid(current).g + norm(ds);
        if gNew < grid(thisNeigh).g
            grid(thisNeigh).g = gNew;
            grid(thisNeigh).f = gNew + grid(thisNeigh).h;
            grid(thisNeigh).parent = current;
        end
    end
end
%close "current"
grid(current).state = -1;
%check if there are still open nodes
states = [grid.state];
openIDs = [];
for i = 1:length(states)
    if states(i) == 1
        openIDs = [openIDs, i];
    end
end
if isempty(openIDs)
    nodesOpen = false;
else
    %find new value for "current"
    fVals = [];
    for j = 1:length(openIDs)
        fVals = [fVals, grid(openIDs(j)).f];
    end
    [fmin, minInd] = min(fVals);
    current = openIDs(minInd);

end

