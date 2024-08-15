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
        dh          % Denavit-Hartenberg parameters
        m           % Mass of the link
        r           % Center of mass (3x1 vector)
        I           % Inertia tensor (3x3 matrix)
    end

    properties (Access=private, Constant)
        defaultName = 'NewLink';          % Default name for the link
        defaultType = 'Revolute';         % Default joint type
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
            %   dhparams - (optional) DH parameters as a 1x4 vector [theta, d, a, alpha].
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
                obj.dh = obj.defaultDH;
            else
                obj.dh = dhparams;
            end

            % Parse optional name-value pair arguments for other properties
            parser = inputParser;
            addParameter(parser, 'Name', obj.defaultName, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'Type', obj.defaultType, @(x) ischar(x) || isstring(x));
            addParameter(parser, 'm', obj.defaultM, @isscalar);
            addParameter(parser, 'r', obj.defaultR, @(x) isnumeric(x) && numel(x) == 3);
            addParameter(parser, 'I', obj.defaultI, @(x) isnumeric(x) && all(size(x) == [3 3]));

            % Parse the name-value pair arguments
            parse(parser, varargin{:});
            
            % Assign parsed values to object properties
            obj.name = parser.Results.Name;
            obj.type = parser.Results.Type;
            obj.m = parser.Results.m;
            obj.r = parser.Results.r;
            obj.I = parser.Results.I;
        end
    end
end