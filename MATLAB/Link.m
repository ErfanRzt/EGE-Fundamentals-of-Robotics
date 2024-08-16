classdef Link < matlab.mixin.Copyable
    % LINK Class representing a single rigid link in a serial manipulator.
    % 
    % This class defines a rigid link object characterized by its
    % Denavit-Hartenberg (DH) parameters, dynamic properties such as mass,
    % center of mass, and inertia tensor. It also supports copying the object 
    % to create independent instances.
    %
    % Properties:
    %   name  - Name of the link (default: 'NewLink')
    %   type  - Type of the joint, either 'Revolute' or 'Prismatic' (default: 'Revolute')
    %   dh    - Denavit-Hartenberg parameters [theta, d, a, alpha] (default: [0, 0, 0, 0])
    %   m     - Mass of the link (default: 0)
    %   r     - Center of mass in the local frame (3x1 vector) (default: [0; 0; 0])
    %   I     - Inertia tensor in the local frame (3x3 matrix) (default: zeros(3,3))
    %
    % Methods:
    %   Link  - Constructor method for initializing the Link object.

    properties
        name        % Name of the link
        type        % Type of the joint: 'Revolute' or 'Prismatic'

        % kinematic level
        q

        m           % Mass of the link
        r           % Center of mass (3x1 vector)
        I           % Inertia tensor (3x3 matrix)
    end

    properties (Dependent = true, SetAccess = protected)
        dh          % Denavit-Hartenberg parameters
        homogtf     % Homogenous Matrix Transformation
    end

    properties (Access = protected)
        dhconst
    end

    properties (Constant, Access = protected)
        defaultName = 'NewLink';          % Default name for the link
        defaultType = 'Revolute';         % Default joint type
        defaultPose = 0;
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
            %   dhparams - DH parameters as a 1x4 vector [theta, d, a, alpha].
            %              If not provided, default is [0, 0, 0, 0].
            %
            %   Name-Value Pair Arguments:
            %     'Name' - (optional) Name of the link (default: 'NewLink').
            %     'Type' - (optional) Type of joint: 'Revolute' or 'Prismatic' (default: 'Revolute').
            %     'm'    - (optional) Mass of the link (default: 0).
            %     'r'    - (optional) Center of mass as a 3x1 vector (default: [0; 0; 0]).
            %     'I'    - (optional) Inertia tensor as a 3x3 matrix (default: zeros(3,3)).
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
            addParameter(parser, 'q', obj.defaultPose, @isscalar);
            addParameter(parser, 'm', obj.defaultM, @isscalar);
            addParameter(parser, 'r', obj.defaultR, @(x) isnumeric(x) && numel(x) == 3);
            addParameter(parser, 'I', obj.defaultI, @(x) isnumeric(x) && all(size(x) == [3 3]));

            % Parse the name-value pair arguments
            parse(parser, varargin{:});
            
            % Assign parsed values to object properties
            obj.name = parser.Results.Name;
            obj.type = parser.Results.Type;
            obj.q = parser.Results.q;
            obj.m = parser.Results.m;
            obj.r = parser.Results.r;
            obj.I = parser.Results.I;
        end

        function dh = get.dh(obj)
            linkType = lower(obj.type);
            if strcmp(linkType, 'revolute') || strcmp(linkType, 'r')
                dh = [obj.dhconst] .* [0, 1, 1, 1] + [obj.q, 0, 0, 0];
            else
                dh = [obj.dhconst] .* [1, 0, 1, 1] + [0, obj.q, 0, 0];
            end
        end

        function homogtf = get.homogtf(obj)
            % GET.HOMOGTF Calculates consecutive homogeneous transforms between coordinate frames.
            homogtf = cell2mat(dhTransforms(obj.dh));
        end
    end
end
