function [Xnon, Ynon, Znon, Xclosed, Yclosed, Zclosed] = construct_nodes(grid, threeDim)
% construct_nodes separates the closed (state == -1) nodes from the
% non-closed (state == 0 or state == 1) nodes. Separate arrays are created
% for the x, y, and (possibly) z position values for both sets of nodes.

%separate closed and non-closed IDs
states = [grid.state];
nonClosedIDs = [];
closedIDs = [];
for i = 1:length(states)
    if states(i) == -1
        closedIDs = [closedIDs, i];
    else
        nonClosedIDs = [nonClosedIDs, i];
    end
end
%get positions
Xnon = [];
Ynon = [];
Xclosed = [];
Yclosed = [];
for i = 1:length(nonClosedIDs)
    Xnon = [Xnon, grid(nonClosedIDs(i)).pos(1)];
    Ynon = [Ynon, grid(nonClosedIDs(i)).pos(2)];
end
for i = 1:length(closedIDs)
    Xclosed = [Xclosed, grid(closedIDs(i)).pos(1)];
    Yclosed = [Yclosed, grid(closedIDs(i)).pos(2)];
end
Znon = [];
Zclosed = [];
if threeDim == true
    for i = 1:length(nonClosedIDs)
        Znon = [Znon, grid(nonClosedIDs(i)).pos(3)];
    end
    for i = 1:length(closedIDs)
        Zclosed = [Zclosed, grid(closedIDs(i)).pos(3)];
    end
end
end

