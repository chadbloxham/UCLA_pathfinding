function [startPos, finPos] = process_map_input(rgb)
% process_map_input is called if the user chooses to pathfind on the UCLA
% campus map. It asks the user to input starting and finishing pixel
% positions. The dimensions of the image are displayed so the user knows
% the acceptable ranges of pixel positions. Improper inputs (non-integer,
% negative, etc.) will yield an error message and the user will once again 
% be prompted for input.

dim = size(rgb);
numRows = dim(1);
numCols = dim(2);
fprintf('Maximum x position: %i\n', numCols);
fprintf('Maximum y position: %i\n', numRows);
prompt = 'Enter starting x position (integer b/w 1 and xMax): ';
startX = input(prompt);
while ~(startX - floor(startX) == 0 && startX > 0 && startX <= numCols)
    fprintf('Error: Input must be positive integer less than xMax.\n');
    startX = input(prompt);
end
prompt = 'Enter starting y position (integer b/w 1 and yMax): ';
startY = input(prompt);
while ~(startY - floor(startY) == 0 && startY > 0 && startY <= numRows)
    fprintf('Error: Input must be positive integer less than yMax.\n');
    startY = input(prompt);
end
startPos = [startX, startY];
prompt = 'Enter finishing x position (integer b/w 1 and xMax): ';
finX = input(prompt);
while ~(finX - floor(finX) == 0 && finX > 0 && finX <= numCols)
    fprintf('Error: Input must be positive integer less than xMax.\n');
    finX = input(prompt);
end
prompt = 'Enter finishing y position (integer b/w 1 and yMax): ';
finY = input(prompt);
while ~(finY - floor(finY) == 0 && finY > 0 && finY <= numRows)
    fprintf('Error: Input must be positive integer less than yMax.\n');
    finY = input(prompt);
end
finPos = [finX, finY];

end

