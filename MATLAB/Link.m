classdef Link < matlab.mixin.Copyable
    % LINK Class representing a single rigid link in a serial manipulator.
    %
    % This class defines a rigid link object characterized by its Denavit-Hartenberg (DH) 
    % parameters, dynamic properties such as mass, center of mass, and inertia tensor. 
    % It also supports copying the object to create independent instances.
    %
    % Properties:
    %   name        - (char or string) Name of the link (default: 'NewLink')
    %   type        - (char or string) Type of the joint, either 'Revolute' or 'Prismatic' (default: 'Revolute')
    %   q           - (scalar) Joint variable (default: 0)
    %   qlim        - (1x2 numeric array) Joint limits [min, max] (default: [-inf, inf])
    %   m           - (scalar) Mass of the link (default: 0)
    %   r           - (3x1 numeric vector) Center of mass in the local frame (default: [0; 0; 0])
    %   I           - (3x3 numeric matrix) Inertia tensor in the local frame (default: zeros(3,3))
    %
    % Dependent Properties (Read-only):
    %   dh          - (1x4 numeric array) Denavit-Hartenberg parameters [theta, d, a, alpha]
    %   homogtf     - (4x4 numeric matrix) Homogeneous transformation matrix
    %
    % Methods:
    %   Link        - Constructor method for initializing the Link object.

    properties
        name        % Name of the link
        type        % Type of the joint: 'Revolute' or 'Prismatic'

        qlim        % Joint limits [min, max]
        offset      % Offset from the input joint variable
        q           % Joint variable

        theta
        d
        a
        alph

        m           % Mass of the link
        r           % Center of mass (3x1 vector)
        I           % Inertia tensor (3x3 matrix)
    end

    properties (Dependent = true, SetAccess = protected)
        dh          % Denavit-Hartenberg parameters
        homogtf     % Homogeneous transformation matrix
    end

    properties (Access = protected)
        dhconst     % Constant DH parameters
    end

    properties (Constant, Access = protected)
        defaultName = 'NewLink';          % Default name for the link
        defaultType = 'Revolute';         % Default joint type
        defaultQLim = [-inf, inf];        % Default joint limits
        defaultQ = 0;                     % Default joint variable
        defaultM = 0;                     % Default mass
        defaultR = [0; 0; 0];             % Default center of mass
        defaultI = zeros(3, 3);           % Default inertia tensor
        defaultDH = [0, 0, 0, 0];         % Default DH parameters
    end
    
    methods
        function obj = Link(dhparams, varargin)
            % LINK Constructor for creating a Link object.
            %
            % Syntax:
            %   obj = Link(dhparams)
            %   obj = Link(dhparams, 'PropertyName', PropertyValue, ...)
            %
            % Description:
            %   Constructs a Link object with specified Denavit-Hartenberg (DH) 
            %   parameters and optional dynamic properties.
            %
            % Input Arguments:
            %   dhparams - (1x4 numeric array) DH parameters [theta, d, a, alpha].
            %              If not provided, default is [0, 0, 0, 0].
            %
            %   Name-Value Pair Arguments:
            %     'Name'    - (char or string, optional) Name of the link (default: 'NewLink').
            %     'Type'    - (char or string, optional) Type of joint: 'Revolute' or 'Prismatic' (default: 'Revolute').
            %     'qlim'    - (1x2 numeric array, optional) Joint limits [min, max] (default: [-inf, inf]).
            %     'q'       - (scalar, optional) Joint variable (default: 0).
            %     'm'       - (scalar, optional) Mass of the link (default: 0).
            %     'r'       - (3x1 numeric vector, optional) Center of mass (default: [0; 0; 0]).
            %     'I'       - (3x3 numeric matrix, optional) Inertia tensor (default: zeros(3,3)).
            %
            % Output:
            %   obj - Instance of the Link class.

            % Check if DH parameters are provided; otherwise, use default
            if nargin < 1 || isempty(dhparams)
                obj.dhconst = obj.defaultDH;
            else
                obj.dhconst = dhparams;
            end

            % Parse optional name-value pair arguments for other properties
            parser = inputParser;
            addParameter(parser, 'Name', obj.defaultName, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'Type', obj.defaultType, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'qlim', obj.defaultQLim, @(x) isnumeric(x) && numel(x) == 2);
            addParameter(parser, 'm', obj.defaultM, @isscalar);
            addParameter(parser, 'r', obj.defaultR, @(x) isnumeric(x) && numel(x) == 3);
            addParameter(parser, 'I', obj.defaultI, @(x) isnumeric(x) && all(size(x) == [3 3]));

            % Parse the name-value pair arguments
            parse(parser, varargin{:});
            
            % Assign parsed values to object properties
            obj.name = parser.Results.Name;
            obj.type = parser.Results.Type;
            obj.qlim = parser.Results.qlim;
            obj.m = parser.Results.m;
            obj.r = parser.Results.r;
            obj.I = parser.Results.I;

            if isRevolute(obj)
                obj.offset = obj.dhconst(1);  % Offset is theta for revolute joints
            else
                obj.offset = obj.dhconst(2);  % Offset is d for prismatic joints
            end

            obj.q = obj.defaultQ;
        end

        function set.qlim(obj, value)
            % SET.QLIM Sets the joint limits and updates the joint variable.
            %
            % Input:
            %   value - (1x2 numeric array) Joint limits [min, max].
            %
            % Note:
            %   Setting joint limits will trigger the update of the joint variable.

            obj.qlim = value;
            obj.q = obj.defaultQ;   % This will trigger the set.q method
        end

        function set.q(obj, value)
            % SET.Q Sets the joint variable within the specified limits.
            %
            % Input:
            %   value - (scalar) Joint variable.
            %
            % Note:
            %   The joint variable is adjusted to be within the limits specified by qlim.
            
            upper_lim = max(obj.qlim);
            lower_lim = min(obj.qlim);

            if value >= upper_lim
                obj.q = upper_lim;
            elseif value <= lower_lim
                obj.q = lower_lim;
            else
                obj.q = value;
            end
        end

        function dh = get.dh(obj)
            % GET.DH Returns the Denavit-Hartenberg parameters.
            %
            % Output:
            %   dh - (1x4 numeric array) DH parameters [theta, d, a, alpha].
            %        Depending on the joint type, theta or d is adjusted by the joint variable q.

            if isRevolute(obj)
                dh = [obj.dhconst] .* [0, 1, 1, 1] + [obj.q + obj.offset, 0, 0, 0];
            else
                dh = [obj.dhconst] .* [1, 0, 1, 1] + [0, obj.q + obj.offset, 0, 0];
            end
        end

        function homogtf = get.homogtf(obj)
            % GET.HOMOGTF Calculates the homogeneous transformation matrix.
            %
            % Output:
            %   homogtf - (4x4 numeric matrix) Homogeneous transformation matrix from the DH parameters.

            homogtf = cell2mat(dhTransforms(obj.dh));
        end
    end

    methods (Access = private)
        function isrev = isRevolute(obj)
            % ISREVOLUTE Checks if the link is a revolute joint.
            %
            % Output:
            %   isrev - (logical) True if the link is a revolute joint, otherwise false.

            isrev = false;

            linkType = lower(obj.type);
            if strcmp(linkType, 'revolute') || strcmp(linkType, 'r')
                isrev = true;
            end
        end

        function ispris = isPrismatic(obj)
            % ISPRISMATIC Checks if the link is a prismatic joint.
            %
            % Output:
            %   ispris - (logical) True if the link is a prismatic joint, otherwise false.

            ispris = ~isRevolute(obj);
        end
    end
end
