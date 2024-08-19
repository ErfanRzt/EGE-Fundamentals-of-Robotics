classdef SerialLinkManipulator < handle
    % SERIALLINKMANIPULATOR Class representing a serial link manipulator.
    %
    % This class models a serial link manipulator using a vector of Link 
    % objects. It constructs the manipulator by aggregating properties of
    % individual links and managing the manipulator's base and tool transformations.
    %
    % Properties:
    %   name          - Name of the manipulator.
    %   description   - Description or comments about the manipulator.
    %   links         - Array of Link objects representing the links of the manipulator.
    %   nLinks        - Number of links in the manipulator.
    %   nJoints       - Number of joints in the manipulator.
    %   q             - Joint space vector variables.
    %   x             - Task space vector variables.
    %   dh            - Standard DH table.
    %   base          - Homogeneous transformation from world to base frame (default: eye(4)).
    %   tool          - Homogeneous transformation from base to end-effector.
    %   jointPose     - Position of each joint.
    %   homogtf       - Consecutive homogeneous transforms between coordinate frames.
    %   homogtf2base  - Homogeneous transforms from each coordinate frame to the base.
    %   gravity       - Vector representing gravitational effects.

    properties
        name          % Name of the manipulator
        description   % Description or comments about the manipulator

        links         % Array of Link objects

        base          % Homogeneous transformation from world to base frame
        gravity       % Vector representing gravitational effects
    end

    properties (Dependent = true, SetAccess = protected)
        nLinks        % Number of links in the manipulator
        nJoints       % Number of joints in the manipulator
        dh            % Standard DH table

        q             % Joint space vector variables
        x             % Task space vector variables
        jointPose     % Position of each joint

        tool          % Homogeneous transformation from base to end-effector
        homogtf       % Consecutive homogeneous transforms between coordinates
        homogtf2base  % Homogeneous transforms from each coordinate frame to base
    end

    properties (Access = protected)
        defaultName = 'NewRobot'
        defaultDescription = 'Serial Rigid Link Robot'
        defaultGravity = [0; 0; -9.81]
        defaultBase = eye(4)
    end

    methods
        function obj = SerialLinkManipulator(links, varargin)
            % SERIALLINKMANIPULATOR Construct a serial link manipulator.
            %
            % Syntax:
            %   obj = SerialLinkManipulator(links, 'Name', value, ...)
            %
            % Description:
            %   Initializes the manipulator using a vector of Link objects. 
            %   Aggregates properties like DH parameters and calculates various
            %   transformation matrices and joint information.
            %
            % Input:
            %   links - Array of Link objects representing the links of the manipulator.
            %
            % Optional Name-Value Pair Arguments:
            %   'Name'        - Name of the manipulator (default: 'NewRobot').
            %   'Description' - Description or comments (default: 'Serial Rigid Link Manipulator').
            %   'Gravity'     - Gravity vector affecting the manipulator (default: [0; 0; -9.81]).
            %   'Base'        - Homogeneous transformation from world to base frame (default: eye(4)).
            %   'q'           - Initial joint space vector variables.
            
            % Initialize properties
            obj.links = links;

            % Validate and assign input arguments
            parser = inputParser;
            addParameter(parser, 'Name',        obj.defaultName,        @(x) ischar(x) || isstring(x));
            addParameter(parser, 'Description', obj.defaultDescription, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'Gravity',     obj.defaultGravity,     @(x) isnumeric(x) && numel(x) == 3);
            addParameter(parser, 'Base',        obj.defaultBase,        @(x) isnumeric(x) && all(size(x) == [4 4]));

            parse(parser, varargin{:});

            % Assign parsed values to object properties
            obj.name = parser.Results.Name;
            obj.description = parser.Results.Description;
            obj.gravity = parser.Results.Gravity;
            obj.base = parser.Results.Base;
        end
    end
    
    methods
        function nLinks = get.nLinks(obj)
            % GET.NLINKS Returns the number of links.
            nLinks = numel(obj.links);
        end
        
        function nJoints = get.nJoints(obj)
            % GET.NJOINTS Returns the number of joints.
            nJoints = obj.nLinks; % Assuming one joint per link
        end

        function dh = get.dh(obj)
            % GET.DH Retrieves the standard DH table.
            dh = vertcat(obj.links.dh);
        end

        function q = get.q(obj)
            q = [obj.links.q]';
        end

        function x = get.x(obj)
            % GET.X Calculates the task space vector variables.
            x = obj.tool(1:3, 4);
        end
        
        function jointPose = get.jointPose(obj)
            % GET.JOINTPOSE Calculates the pose (position and orientation) of each joint.
            jointPose = zeros(3,  obj.nJoints);
            jointPose(:,1)  = obj.base(1:3, 4);
            for i = 1:obj.nJoints-1
                homog2base = cell2mat(obj.homogtf2base(i));
                jointPose(:, i+1) = homog2base(1:3, 4);
            end
        end
        
        function toolTransform = get.tool(obj)
            % GET.TOOL Retrieves the homogeneous transformation from base to end-effector.
            toolTransform = cell2mat(obj.homogtf2base(obj.nLinks));
        end
        
        function homogtf = get.homogtf(obj)
            % GET.HOMOGTF Calculates consecutive homogeneous transforms between coordinate frames.
            homogtf = vertcat(obj.links.homogtf);
            homogtf = mat2cell(homogtf, 4*ones([1, obj.nJoints]), 4);
        end
        
        function homogtf2base = get.homogtf2base(obj)
            % GET.HOMOGTF2BASE Calculates homogeneous transforms from each coordinate frame to the base.
            homogtf2base = homogTF2Base(obj.homogtf);
        end
        
        % Additional methods for kinematics, dynamics, etc., can be added here
    end
end
