function plot2DStdFrame(varargin)
    % PLOT2DSTDFRAME Plots a 2D Cartesian coordinate system at the origin.
    %
    %   plot2DStdFrame() plots a standard 2D coordinate frame at the origin
    %   with default settings.
    %
    %   plot2DStdFrame('Name', Value, ...) allows customization of the frame
    %   by specifying name-value pair arguments. The available parameters are:
    %       'Scale'     - Scalar or 1x2 vector defining basis vector lengths
    %       'LineWidth' - Line width for the quiver plot
    %       'Color'     - Cell array of colors for each axis (default {'r', 'g'})
    %
    %   Example:
    %       plot2DStdFrame('Scale', 2, 'LineWidth', 3);

    % Call plot2DFrame with the identity rotation matrix and zero translation vector.
    % varargin{:} allows for any additional name-value pair arguments to be passed.
    plot2DFrame(eye(2), [0, 0], varargin{:});
end
