function varargout = plot3DFrame(homogMatrix, varargin)
    % PLOT3DFRAME Draw a 3-D Cartesian coordinate system.
    %
    %   plot3DFrame(rotationMatrix, translationVector)
    %   plot3DFrame(rotationMatrix, translationVector, 'Scale', 2, 'LineWidth', 3)
    %
    %   Name-Value Pair Arguments:
    %   - 'Scale': Scalar or 1x3 vector defining basis vector lengths (default: 1)
    %   - 'LineWidth': Line width for the quiver plot (default: 2)
    %   - 'Color': Cell array of colors for each axis (default: {'r', 'g', 'b'})
    %
    %   OUTPUT:
    %   - If requested, returns the handle of the current axes (gca).

    % Define default values for optional arguments
    defaultScale = 1;                 % Default scale for basis vectors
    defaultLineWidth = 2;             % Default line width for quiver plot
    defaultColor = {'r', 'g', 'b'};   % Default colors for the x, y, and z axes

    % Validate input arguments
    validateattributes(homogMatrix, {'numeric'}, {'size', [4, 4]}, 'plot3DFrame', 'homogMatrix');

    % Create an input parser object to handle name-value pair arguments
    parser = inputParser;
    addParameter(parser, 'Scale', defaultScale, @(x) isscalar(x) || (isvector(x) && length(x) == 3));
    addParameter(parser, 'LineWidth', defaultLineWidth, @isscalar);
    addParameter(parser, 'Color', defaultColor, @(x) iscell(x) && length(x) == 3);

    % Parse the name-value pair arguments
    parse(parser, varargin{:});

    % Extract parsed values from the parser results
    scale = parser.Results.Scale;
    lineWidth = parser.Results.LineWidth;
    colors = parser.Results.Color;

    % Extract Rotation Matrix and Translation Vector from Homogenous Matrix
    rotationMatrix = homogMatrix(1:3, 1:3);
    translationVector = homogMatrix(1:3,4);

    % Ensure scale is a 1x3 vector
    if isscalar(scale)
        scale = scale * [1, 1, 1];  % Convert scalar to a 1x3 vector
    end

    % Compute basis vectors by scaling the rotation matrix
    basisVectors = rotationMatrix .* scale;

    % Create a 3D quiver plot for each axis
    hold on; % Keep the current plot
    for i = 1:3
        % Plot each axis with the specified color and line width
        quiver3(translationVector(1), translationVector(2), translationVector(3), ...
                basisVectors(1, i), basisVectors(2, i), basisVectors(3, i), ...
                'Color', colors{i}, 'LineWidth', lineWidth, 'MaxHeadSize', 0.4);
    end
    % scatter3(translationVector(1), translationVector(2), translationVector(3), 'MarkerFaceColor', 'k');
    hold off; % Release the current plot

    % Output the plot handle if requested
    if nargout > 0
        varargout = {gca}; % Return the handle to the current axes
    end
end