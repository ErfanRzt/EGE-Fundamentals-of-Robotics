classdef Link < matlab.mixin.Copyable
    properties
        name        % Name of the link
        type        % Type of the joint: 'Revolute' or 'Prismatic'
        dh          % Denavit-Hartenberg parameters
        m           % Mass of the link
        r           % Center of mass (3x1 vector)
        I           % Inertia tensor (3x3 matrix)
    end

    properties (Access=private, Constant)
        defaultName = 'NewLink';
        defaultType = 'Revolute';
        defaultM = 0;
        defaultR = [0; 0; 0];
        defaultI = zeros(3, 3);  % Inertia matrix initialized to zero
        defaultDH = [0, 0, 0, 0];  % Default DH parameters
    end
    
    methods
        function obj = Link(dhparams, varargin)
            % Constructor method for the Link class
            % dhparams - Denavit-Hartenberg parameters (positional argument)

            % Check if DH parameters are provided, if not, use default
            if nargin < 1 || isempty(dhparams)
                obj.dh = obj.defaultDH;
            else
                obj.dh = dhparams;
            end

            % Parse the name-value pair arguments for other properties
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
