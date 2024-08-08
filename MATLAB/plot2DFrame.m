function varargout = plot2DFrame(rotationMatrix, translationVector, varargin)
% PLOT2DFRAME Plot a 2-D Cartesian coordinate system.
%
%   plot2DFrame(rotationMatrix, translationVector)
%   plot2DFrame(rotationMatrix, translationVector, 'Scale', 2, 'LineWidth', 3)
%
%   Name-Value Pair Arguments:
%   - 'Scale': Scalar or 1x2 vector defining basis vector lengths (default: 1)
%   - 'LineWidth': Line width for the quiver plot (default: 2)
%   - 'Color': Cell array of colors for each axis (default: {'r', 'g'})
%
%   OUTPUT:
%   - If requested, returns the handle of the current axes (gca).

    % Define default values for optional arguments
    defaultScale = 1;                 % Default scale for basis vectors
    defaultLineWidth = 2;             % Default line width for quiver plot
    defaultColor = {'r', 'g'};        % Default colors for the x and y axes

    % Validate input arguments
    validateattributes(rotationMatrix, {'numeric'}, {'size', [2, 2]}, 'plot2DFrame', 'rotationMatrix');
    validateattributes(translationVector, {'numeric'}, {'size', [1, 2]}, 'plot2DFrame', 'translationVector');

    % Create an input parser object to handle name-value pair arguments
    parser = inputParser;
    addParameter(parser, 'Scale', defaultScale, @(x) isscalar(x) || (isvector(x) && length(x) == 2));
    addParameter(parser, 'LineWidth', defaultLineWidth, @isscalar);
    addParameter(parser, 'Color', defaultColor, @(x) iscell(x) && length(x) == 2);

    % Parse the name-value pair arguments
    parse(parser, varargin{:});

    % Extract parsed values from the parser results
    scale = parser.Results.Scale;
    lineWidth = parser.Results.LineWidth;
    colors = parser.Results.Color;

    % Ensure scale is a 1x2 vector
    if isscalar(scale)
        scale = [scale, scale]; % Convert scalar to a 1x2 vector
    end

    % Compute basis vectors by scaling the rotation matrix
    basisVectors = rotationMatrix .* scale;

    % Create a 2D quiver plot for each axis
    hold on; % Keep the current plot
    for i = 1:2
        % Plot each axis with the specified color and line width
        quiver(translationVector(1), translationVector(2), ...
               basisVectors(1, i), basisVectors(2, i), ...
               'Color', colors{i}, 'LineWidth', lineWidth, 'MaxHeadSize', 0.4);
    end
    hold off; % Release the current plot

    % Output the plot handle if requested
    if nargout > 0
        varargout = {gca}; % Return the handle to the current axes
    end
end
