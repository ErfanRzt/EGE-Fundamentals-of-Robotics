function plotPoint(p, varargin)
% PLOTPOINT Plots a 3D point with customizable marker properties.
% 
%   plotPoint(p) plots the 3D point p using default marker properties.
%   plotPoint(p, 'Name', Value, ...) allows customization of the marker 
%   properties using Name-Value pair arguments.
%
%   Inputs:
%   - p: A 3-element vector specifying the [x, y, z] coordinates of the point.
%
%   Name-Value Pair Arguments:
%   - 'Color': A character specifying the color of the marker (default: 'k').
%   - 'MarkerType': A character specifying the marker type (default: 'o').
%   - 'MarkerSize': A numeric value specifying the size of the marker (default: 1).
%
%   Example:
%   plotPoint([1, 2, 3], 'Color', 'r', 'MarkerType', 'x', 'MarkerSize', 2);

    % Define default marker properties
    defaultColor = 'k';            % Default color: black
    defaultMarkerType = 'o';       % Default marker type: circle
    defaultMarkerSize = 1;         % Default marker size: 1

    initMarkerSize = 25;           % [Const.] Default initial marker size

    % Create an input parser object
    parser = inputParser;
    
    % Add parameters with default values and validation functions
    addParameter(parser, 'Color', defaultColor, @(x) ischar(x) && length(x) == 1);
    addParameter(parser, 'MarkerType', defaultMarkerType, @(x) ischar(x));
    addParameter(parser, 'MarkerSize', defaultMarkerSize, @(x) isnumeric(x));

    % Parse the name-value pair arguments
    parse(parser, varargin{:});

    % Extract parsed values from the parser results
    color = parser.Results.Color;
    markerType = parser.Results.MarkerType;
    markerSize = parser.Results.MarkerSize;

    % Plot the 3D point using the specified marker properties
    scatter3(p(1), p(2), p(3), initMarkerSize*markerSize, ...
             markerType, 'filled', 'MarkerFaceColor', color);
end
