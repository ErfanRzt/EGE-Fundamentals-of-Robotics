function plot3DStdFrame(varargin)
    % PLOT3DSTDFRAME Plots a 3D Cartesian coordinate system at the origin.
    %
    %   plot3DStdFrame() plots a standard 3D coordinate frame at the origin
    %   with default settings.
    %
    %   plot3DStdFrame('Name', Value, ...) allows customization of the frame
    %   by specifying name-value pair arguments. The available parameters are:
    %       'Scale'     - Scalar or 1x3 vector defining basis vector lengths
    %       'LineWidth' - Line width for the quiver plot
    %       'Color'     - Cell array of colors for each axis
    %
    %   Example:
    %       plot3DStdFrame('Scale', 2, 'LineWidth', 3);

    % Call plot3DFrame with the identity rotation matrix and zero translation vector.
    % varargin{:} allows for any additional name-value pair arguments to be passed.
    plot3DFrame(eye(4), varargin{:});
end
