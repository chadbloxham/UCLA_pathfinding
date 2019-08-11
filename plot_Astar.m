function plot_Astar(x, y, z, Xnon, Ynon, Znon, Xclosed, Yclosed, Zclosed, image, startPos, finPos, map, threeDim)
% plot_Astar uses the positions of the path and all other nodes to plot the
% progress of the A* algorithm. If the user chose to pathfind on the UCLA
% campus map, nodes are displayed over the image.

%if pathfinding in 3D, use z coordinates and the "plot3" function
if threeDim == true
    plot3(Xnon, Ynon, Znon, '.', 'MarkerSize', 8, 'color', 'b');
    hold on;
    plot3(Xclosed, Yclosed, Zclosed, '.', 'MarkerSize', 8, 'color', 'k');
    hold on;
    plot3(x, y, z, '.-', 'MarkerSize', 18);
    plot3(startPos(1), startPos(2), startPos(3), '.', 'MarkerSize', 18, 'color', 'r');
    hold on;
    plot3(finPos(1), finPos(2), finPos(3), '.', 'MarkerSize', 18);
    hold off;
    drawnow;
else
    %if pathfinding on UCLA campus map, display image
    if map == true
        imshow(image, 'InitialMagnification', 40)
        hold on;
    end
    plot(Xnon, Ynon, '.', 'MarkerSize', 8, 'color', 'b');
    hold on;
    plot(Xclosed, Yclosed, '.', 'MarkerSize', 8, 'color', 'k');
    hold on;
    plot(x, y, '.-', 'MarkerSize', 18);
    plot(startPos(1), startPos(2), '.', 'MarkerSize', 18, 'color', 'r');
    hold on;
    plot(finPos(1), finPos(2), '.', 'MarkerSize', 18);
    hold off;
    drawnow;
end

end

