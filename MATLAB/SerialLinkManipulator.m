classdef SerialLinkManipulator < handle
    % SERIALLINKMANIPULATOR Class representing a serial link manipulator.
    %
    % This class models a serial link manipulator using a vector of Link 
    % objects. It initializes the manipulator by aggregating properties from 
    % individual links, such as DH parameters, and manages the manipulator's 
    % base and tool transformations.
    %
    % Properties:
    %   name      - Name of the manipulator.
    %   comment   - Additional comments or description.
    %   gravity   - Gravity vector applied to the manipulator.
    %   q         - Joint space variables (generalized coordinates).
    %   plotopt   - Plotting options for visualization (e.g., colors, styles).
    %   base      - Base transformation matrix (default: identity matrix).
    %
    % Protected Properties:
    %   nLinks    - Number of links in the manipulator.
    %   nJoints   - Number of joints (same as number of links).
    %   links     - Vector of Link objects representing the links.
    %   dh        - Aggregated DH parameters from all links.
    %
    % Dependent Properties:
    %   tool      - Tool transformation matrix.
    %
    % Methods:
    %   SerialLinkManipulator - Constructor to initialize the manipulator with a vector of Link objects.

    properties
        name        % Name of the manipulator
        comment     % Comment or description
        gravity     % Gravity vector (default: [0; 0; 9.81])
        q           % Joint space variables (generalized coordinates)
        plotopt     % Plotting options (e.g., colors, styles)
        base        % Base transformation matrix (default: identity matrix)
    end

    properties (SetAccess = protected)
        nLinks      % Number of links in the manipulator
        nJoints     % Number of joints (same as number of links)
        links       % Vector of Link objects
        dh          % Aggregated DH parameters from all links
    end

    properties (Dependent)
        tool        % Tool transformation matrix
    end

    properties (Constant, Access = protected)
        defaultName = 'NewRobot';                           % Default name for the manipulator
        defaultComment = 'Serial Rigid Link Manipulator';   % Default comment
        defaultGravity = [0; 0; 9.81];                     % Default gravity vector
        defaultBase = eye(4);                             % Default base transformation matrix
    end

    methods
        function robot = SerialLinkManipulator(links, varargin)
            % SERIALLINKMANIPULATOR Construct a serial link manipulator.
            %
            % Syntax:
            %   robot = SerialLinkManipulator(links)
            %
            % Description:
            %   Initializes the manipulator using a vector of Link objects. 
            %   Aggregates the DH parameters and determines the number of 
            %   joints and links in the manipulator.
            %
            % Input:
            %   links - Vector of Link objects representing the links of the manipulator.
            %
            % Optional Name-Value Pair Arguments:
            %   'Name'    - Name of the manipulator (default: 'NewRobot').
            %   'Comment' - Additional comments or description (default: 'Serial Rigid Link Manipulator').
            %   'g'       - Gravity vector (default: [0; 0; 9.81]).
            %   'Base'    - Base transformation matrix (default: identity matrix).
            %
            % Output:
            %   robot - Instance of the SerialLinkManipulator class.

            % Validate the input
            if ~isa(links, 'Link') || ~isvector(links)
                error('Input must be a vector of Link objects.');
            end

            % Parse optional name-value pair arguments
            parser = inputParser;
            addParameter(parser, 'Name', robot.defaultName, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'Comment', robot.defaultComment, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'g', robot.defaultGravity, @(x) isnumeric(x) && numel(x) == 3);
            addParameter(parser, 'Base', robot.defaultBase, @(x) isnumeric(x) && isequal(size(x), [4, 4]));

            parse(parser, varargin{:});
            
            % Assign parsed values to object properties
            robot.name = parser.Results.Name;
            robot.comment = parser.Results.Comment;
            robot.gravity = parser.Results.g;
            robot.base = parser.Results.Base;

            % Initialize properties
            robot.links = links;
            robot.nLinks = numel(links);
            robot.nJoints = robot.nLinks; % Assuming each link corresponds to one joint
            robot.dh = zeros(robot.nLinks, 4); % Preallocate DH parameters matrix

            % Aggregate DH parameters from each link
            for i = 1:robot.nLinks
                robot.dh(i, :) = links(i).dh;
            end
        end
        
        function tool = get.tool(obj)
            % GET.TOOL Returns the tool transformation matrix.
            %
            % Syntax:
            %   tool = obj.tool
            %
            % Output:
            %   tool - Tool transformation matrix. Default implementation returns an identity matrix.
            tool = eye(4); % Default implementation, modify if needed
        end
    end
end
