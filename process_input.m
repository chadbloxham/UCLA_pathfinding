function [numRows, numCols, numPlanes, start, finish] = process_input(threeDim)
% process_input is called if the user chooses to not pathfind on UCLA map.
% It takes user input for the number of rows, columns, and (if the user
% chose to pathfind in 3D) the number of planes in the grid. Additionally,
% the user is prompted to input the starting and finishing node for the
% path A* will attempt to find. Improper inputs (negative, not an integer,
% etc.) will not be accepted and an error message will be displayed. The
% user will be prompted for input again.

numPlanes = 1;
prompt = 'Enter number of rows (positive integer): ';
numRows = input(prompt);
while ~(numRows - floor(numRows) == 0 && numRows > 0)
    fprintf('Error: Input must be an integer greater than 0.\n');
    numRows = input(prompt);
end
prompt = 'Enter number of columns (positive integer): ';
numCols = input(prompt);
while ~(numCols - floor(numCols) == 0 && numCols > 0)
    fprintf('Error: Input must be an integer greater than 0.\n');
    numCols = input(prompt);
end
if threeDim == true
    prompt = 'Enter number of planes (positive integer > 1): ';
    numPlanes = input(prompt);
    while ~(numPlanes - floor(numPlanes) == 0 && numPlanes > 1)
        fprintf('Error: Input must be an integer greater than 1.\n');
        numPlanes = input(prompt);
    end
end
numNodes = numRows * numCols * numPlanes;
fprintf('Number of Nodes: %i\n', numNodes);
prompt = 'Enter ID of start node (integer b/w 1 and numNodes): ';
start = input(prompt);
while ~(start - floor(start) == 0 && start > 0 && start <= numNodes)
    fprintf('Error: Input must be positive integer less than numNodes.\n');
    start = input(prompt);
end
prompt = 'Enter ID of finish node (b/w 1 and numNodes): ';
finish = input(prompt);
while ~(finish - floor(finish) == 0 && finish > 0 && finish <= numNodes)
    fprintf('Error: Input must be positive integer less than numNodes.\n');
    finish = input(prompt);
end

end

