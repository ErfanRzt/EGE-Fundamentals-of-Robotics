classdef SerialLinkManipulator < handle
    % SERIALLINKMANIPULATOR Class representing a serial link manipulator.
    % 
    % This class models a serial link manipulator using a vector of Link 
    % objects. It constructs the manipulator by aggregating properties of
    % individual links and other parameters.
    %
    % Properties:       (PUBLIC)
    %                   can be accessed and modified from outside the class
    %                   by any code that uses the class. READ/WRITE!
    %                   ---
    %   name            [char/string]   Name of the manipulator.
    %   description     [char/string]   Description or comments about the manipulator.
    %   links           [Link array]    Array of Link objects and length N, epresenting the links of the manipulator.
    %   base            [4x4 matrix]    Homogeneous transformation from world to base frame (default: eye(4)).
    %   gravity         [3x1 vector]    Vector representing gravitational effects (default: [0, 0, -9.81]).
    %
    %
    % Properties:       (DEPENDENT, SETACCESS PROTECTED)
    %                   is calculated dynamically when accessed, and it 
    %                   does not store its value internally. READ-ONLY!
    %                   ---
    %   nLinks          [scalar]        Number of links in the manipulator.
    %   nJoints         [scalar]        Number of joints in the manipulator.
    %   q               [Nx1 vector]    Joint space vector variables.
    %   x               [3x1 vector]    Task space vector variables.
    %   dh              [Nx4 matrix]    Standard DH table.
    %   tool            [4x4 matrix]    Homogeneous transformation from base to end-effector.
    %   jointPose       [3xN matrix]    Position of each joint.
    %   homogtf         [cell array]    Consecutive homogeneous transforms between coordinate frames of length N.
    %   homogtf2base    [cell array]    Homogeneous transforms from each coordinate frame to the base of length N.
    %
    %
    % Examples:
    %   o   Create a 2-link RR planar robot
    %       link1 = Link([ 0     0   a1     0], 'name', 'LINK 1');
    %       link2 = Link([ 0     0   a2     0], 'name', 'LINK 2');
    %       robot = SerialLink([link1,  link2], 'name', 'RR Planar Robot');
    %
    %
    % NOTE:
    %   o   This class directly utilizes the Link object type to construct 
    %       a serial link robot manipulator. The Link objects inherit from 
    %       `matlab.mixin.Copyable`, which is an abstract handle class. 
    %       This means that any change in a Link object is reflected in the 
    %       serial link robot object and vice versa. 
    %
    %       This feature effectively binds the serial link robot object to 
    %       its Link objects, ensuring that changes in state and motion are 
    %       consistently propagated. HOWEVER, CAUTION IS ADVISED WHEN USING 
    %       THIS FUNCTIONALITY.
    %
    %   o   Due to this behavior, this class relies on each Link object's 
    %       properties to operate and generate results. For instance, there 
    %       is no independent 'q' vector property for the robot object 
    %       because this vector is derived from each Link's joint value. 
    %       This approach ensures integrity and interchangeable functionality.
    %
    %   o   Refer to the basic architecture of the code below:
    %           -TODO
    %
    %
    % TODO:
    %   ...
    
    properties
        name          % Name of the manipulator (string)
        description   % Description or comments about the manipulator (string)
        links         % Array of Link objects (1xN array)
        base          % Homogeneous transformation from world to base frame (4x4 matrix)
        gravity       % Vector representing gravitational effects (3x1 vector)
    end

    properties (Dependent = true, SetAccess = protected)
        nLinks        % Number of links in the manipulator (scalar)
        nJoints       % Number of joints in the manipulator (scalar)
        q             % Joint space vector variables (Nx1 vector)
        x             % Task space vector variables (3x1 vector)
        J             % Jacobian Matrix
        dh            % Standard DH table (Nx4 matrix)
        tool          % Homogeneous transformation from base to end-effector (4x4 matrix)
        jointPose     % Position of each joint (3xN matrix)
        homogtf       % Consecutive homogeneous transforms between coordinates (Nx1 cell array)
        homogtf2base  % Homogeneous transforms from each coordinate frame to base (Nx1 cell array)
    end

    properties (Access = private)
        defaultName = 'NewRobot';                       % Default name (string)
        defaultDescription = 'Serial Rigid Link Robot'; % Default description (string)
        defaultGravity = [0; 0; -9.81];                 % Default gravity vector (3x1 vector)
        defaultBase = eye(4);                           % Default base transformation (4x4 matrix)
    end

    methods
        function obj = SerialLinkManipulator(links, varargin)
            % SERIALLINKMANIPULATOR Constructor for SerialLinkManipulator.
            %
            % Inputs:
            %   links - Array of Link objects representing the links of the manipulator (1xN array).
            %   varargin - Optional name-value pairs for 'Name', 'Description', 
            %              'Gravity' (3x1 vector), and 'Base' (4x4 matrix).
            %
            % Outputs:
            %   obj - An instance of the SerialLinkManipulator class.
            
            % Initialize properties
            obj.links = links;

            % Parse and assign optional input arguments
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
        function fkin(obj, q)
            % FKIN Computes the forward kinematics for the manipulator.
            %
            % Input:
            %   q - [nJoints x 1 numeric array] Joint variables for each joint in the manipulator.
            %
            % Output:
            %   x - [nJoints x 1 numeric array] Position of the end-effector 
            %       in the base frame.
            %
            % Note:
            %   The joint variables provided in q are assigned to the corresponding link
            %   of the manipulator, and the forward kinematics is calculated based on these values.

            % Assign the joint variables to each corresponding link
            for i = 1:obj.nJoints
                obj.links(i).q = q(i);
            end
            
            % Calculate and return the end-effector position
            obj.x;
        end

        function J = get.J(obj)
            J = zeros([6, obj.nJoints]);
            for i = 1:obj.nJoints
                if obj.links(i).isRevolute()
                    Jvi = cross(obj.links(i).homogtf(1:3, 3), (obj.x - obj.jointPose(:, i)) );
                    Jwi = obj.links(i).homogtf(1:3, 3);
                else
                    Jvi = obj.links(i).homogtf(1:3, 3);
                    Jwi = [0; 0; 0];
                end

                J(:, i) = [Jvi; Jwi];
            end
        end

        function nLinks = get.nLinks(obj)
            % GET.NLINKS Returns the number of links in the manipulator.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   nLinks - Number of links in the manipulator (scalar).

            nLinks = numel(obj.links);
        end
        
        function nJoints = get.nJoints(obj)
            % GET.NJOINTS Returns the number of joints in the manipulator.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   nJoints - Number of joints in the manipulator (scalar).

            nJoints = obj.nLinks;   % Assumes one joint per link
        end

        function dh = get.dh(obj)
            % GET.DH Retrieves the standard DH table for the manipulator.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   dh - Standard DH table (Nx4 matrix).

            dh = vertcat(obj.links.dh);
        end

        function q = get.q(obj)
            % GET.Q Retrieves the joint space vector variables.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   q - Joint space vector variables (Nx1 vector).

            q = [obj.links.q]';
        end

        function x = get.x(obj)
            % GET.X Calculates the task space vector variables.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   x - Task space vector variables representing the end-effector position (3x1 vector).
            x = obj.tool(1:3, 4);
        end
        
        function jointPose = get.jointPose(obj)
            % GET.JOINTPOSE Calculates the pose (position) of each joint in the manipulator.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   jointPose - Position of each joint (3xN matrix).

            jointPose = zeros(3, obj.nJoints);
            jointPose(:,1) = obj.base(1:3, 4);
            for i = 1:obj.nJoints-1
                homog2base = cell2mat(obj.homogtf2base(i));
                jointPose(:, i+1) = homog2base(1:3, 4);
            end
        end
        
        function toolTransform = get.tool(obj)
            % GET.TOOL Retrieves the homogeneous transformation from base to end-effector.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   toolTransform - Homogeneous transformation matrix from base to end-effector (4x4 matrix).

            toolTransform = cell2mat(obj.homogtf2base(obj.nLinks));
        end
        
        function homogtf = get.homogtf(obj)
            % GET.HOMOGTF Calculates consecutive homogeneous transforms between coordinate frames.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   homogtf - Consecutive homogeneous transforms between coordinate frames (4x4xN cell array).

            homogtf = vertcat(obj.links.homogtf);
            homogtf = mat2cell(homogtf, 4*ones([1, obj.nJoints]), 4);
        end
        
        function homogtf2base = get.homogtf2base(obj)
            % GET.HOMOGTF2BASE Calculates the homogeneous transforms from each coordinate frame to the base.
            %
            % Inputs:
            %   obj - An instance of the SerialLinkManipulator class.
            %
            % Outputs:
            %   homogtf2base - Homogeneous transforms from each coordinate frame to the base (4x4xN cell array).

            homogtf2base = homogTF2Base(obj.homogtf);
        end
        
        % Additional methods for kinematics, dynamics, etc., can be added here
    end
end
