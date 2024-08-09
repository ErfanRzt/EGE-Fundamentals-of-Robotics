function plotHomogFrames(homogTransforms, varargin)
% PLOTHOMOGFRAMES Plot a series of 3D frames based on homogeneous transformation matrices.
%
%   plotHomogFrames(homogTransforms)
%   plotHomogFrames(homogTransforms, 'AdditionalNameValuePairs')
%
%   Input Arguments:
%   - homogTransforms: A cell array of homogeneous transformation matrices. 
%     Each cell contains a 4x4 matrix representing the transformation from one joint to the next.
%
%   Name-Value Pair Arguments (optional):
%   - These can be used to pass additional parameters to the `plot3DFrame_mod` function if needed.
%
%   Description:
%   This function plots a sequence of 3D frames for each joint in a robotic arm or similar system. 
%   It first computes the base transforms from the given homogeneous transforms and then plots 
%   each frame using the `plot3DFrame_mod` function.
%
%   Example:
%   plotHomogFrames(homogTransforms, 'Scale', 2, 'LineWidth', 3, 'Color', {'r', 'g', 'b'})

    % Number of joints (i.e., number of transformation matrices)
    nJoints = numel(homogTransforms);

    % Compute base transforms from the homogeneous transformations
    baseTransforms = homogTF2Base(homogTransforms);
    
    % Plot the standard 3D frame for reference
    plot3DStdFrame(varargin{:});
    
    % Plot each frame based on the computed base transforms
    for i = 1:nJoints
        % Convert the cell array element to a matrix and plot it
        plot3DFrame(cell2mat(baseTransforms(i)), varargin{:});
    end
    
    % Label the axes
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    % Set the plot to have equal axis scaling and display the grid
    axis equal;
    grid on;
end
