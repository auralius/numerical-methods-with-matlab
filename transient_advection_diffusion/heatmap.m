% Disable interpolation for faster rendering

function heatmap(data, interpolate)

if interpolate == true
    % Define integer grid of coordinates for the above data
    [X,Y] = meshgrid(1:size(data,2), 1:size(data,1));

    % Define a finer grid of points
    [X2,Y2] = meshgrid(1:0.1:size(data,2), 1:0.1:size(data,1));

    % Interpolate the data and show the output
    interpolated_data = interp2(X, Y, data, X2, Y2, 'linear');
    imagesc('CData', interpolated_data);
else
    imagesc('CData', data);
end

colormap(jet);
colorbar;

drawnow;
end