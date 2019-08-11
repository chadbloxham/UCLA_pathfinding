%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Chad Bloxham 
%
%  Main file for A* path finding program. Capable of path finding on a jpg
%  image of the UCLA campus map or on basic grids of points (in 2D or 3D).
%
%  Initial draft: December 2017 for CS M20: Intro to MatLab at UCLA.
%  This updated version was created in August 2019.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all; %close windows, clear variables and command line
map = false;
threeDim = false;
image = 'UCLA_map.jpg'; %image of UCLA campus map
%get input from user on using UCLA map and (if needed), 2D or 3D grid
prompt = 'Pathfind on UCLA campus map? (y or n): ';
resp = input(prompt, 's');
%error handling for improper input from user
while resp ~= 'y' && resp ~= 'n'
    fprintf('Error: Input must be either y or n.\n');
    resp = input(prompt, 's');
end
if resp == 'y' %user wants to pathfind on UCLA map
    map = true;
    rgb = imread(image); %get rgb values for each pixel in the map
    %enter starting and finishing pixel positions for path
    [startPos, finPos] = process_map_input(rgb); 
    %only create grid if it has not already been generated
    if isfile('map_grid.mat')
        load('map_grid.mat', 'grid')
    else
        %create grid on which the A* algorithm will be run using rgb vals
        grid = initGridImage(rgb); 
        save('map_grid.mat', 'grid')
    end
    %identify nodes closest to inputted start and finish pixel positions
    dStart = [];
    dFinish = [];
    numNodes = length([grid.ID]);
    for i = 1:numNodes
        dStart = [dStart, norm(grid(i).pos - startPos)];
        dFinish = [dFinish, norm(grid(i).pos - finPos)];
    end
    [minStartDist, start] = min(dStart);
    [minFinDist, finish] = min(dFinish);
    %initialize state of start node
    grid(start).state = 1;
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
    
else %user will pathfind on a grid of points not derived from the UCLA map
    prompt = 'Pathfind in 3D? Will pathfind in 2D otherwise. (y or n): ';
    resp = input(prompt, 's');
    while resp ~= 'y' && resp ~= 'n'
        fprintf('Error: Input must be either y or n.\n');
        resp = input(prompt, 's');
    end
    if resp == 'y' %will pathfind on 3D grid
        threeDim = true;
    end
    %prompt user for info regarding grid and start/finish nodes of path
    [numRows, numCols, numPlanes, start, finish] = process_input(threeDim);
    %generate grid which the A* algorithm will run on
    grid = initGrid3D(numRows, numCols, numPlanes, start, finish, threeDim);
end

%main while loop which will plot the grid and path as it is discovered
startPos = grid(start).pos;
finPos = grid(finish).pos;
current = start;
%A* is over once we have found a path from the start to finish node OR
%there are no nodes available to be chosen as the minimum f node (current)
pathFound = false;
nodesOpen = true;
while nodesOpen && ~pathFound
    %find the nodes and positions in the path begin considered
    [x, y, z, pathIDs, pathLen] = construct_path(grid, current, threeDim);
    %find the positions of both the closed and non-closed nodes in the grid 
    [Xnon, Ynon, Znon, Xclosed, Yclosed, Zclosed] = construct_nodes(grid, threeDim);
    %plot path, grid, and display the UCLA campus map image (if applicable)
    plot_Astar(x, y, z, Xnon, Ynon, Znon, Xclosed, Yclosed, Zclosed, image, startPos, finPos, map, threeDim);
    if current == finish
        pathFound = true; %solution found
    else
        %find next "current node" (min. f value) and update its neighbors 
        [grid, current, nodesOpen] = pathfind(grid, current);
    end
end
%if path found, display info about path
if pathFound == true
    finText = "Path Found!" + newline + newline + "Nodes in path:" + newline;
    for i = 1:length(pathIDs)
        finText = finText + string(pathIDs(i)) + " ";
    end
    finText = finText + newline + newline + "Path length = " + string(pathLen);
    bx = msgbox(finText);
elseif nodesOpen == false %display failure message
    finText = "Path from node " + string(start) + " to node " + string(finish) + " does not exist.";
    bx = msgbox(finText);
end