classdef PrismaticLink < Link
    methods
        function obj = PrismaticLink(theta, a, alpha, offset, varargin)
            % PRISMATICLINK Construct an instance of this class.
            %
            % Syntax:
            %   obj = PrismaticLink(theta, a, alpha, offset)
            %   obj = PrismaticLink(theta, a, alpha, offset, 'PropertyName', PropertyValue, ...)
            %
            % Description:
            %   Creates a PrismaticLink object using specified Denavit-Hartenberg (DH) 
            %   parameters for a prismatic joint along with optional dynamic properties.
            %
            % Input Arguments:
            %   theta   - [scalar] Joint rotation angle
            %   a       - [scalar] Link length
            %   alpha   - [scalar] Link twist
            %   offset  - [scalar] Link perpendicular distance offset
            %
            %   Name-Value Pair Arguments:
            %     'Name'    - [char or string]  Name of the link (default: 'NewLink').
            %   * 'Type'    - [char or string]  (WARNING) DO NOT MODIFY! Filled internally as 'Prismatic'.
            %     'qlim'    - [1x2 array]       Joint limits [min, max] (default: [-inf, inf]).
            %     'm'       - [scalar]          Mass of the link (default: 0).
            %     'r'       - [3x1 vector]      Center of mass (default: [0; 0; 0]).
            %     'I'       - [3x3 matrix]      Inertia tensor (default: zeros(3,3)).
            %
            % Output:
            %   obj     - Instance of the PrismaticLink class.
            
            dhparameters = [theta, offset, a, alpha];
            obj = obj@Link(dhparameters, 'type', 'Prismatic', varargin{:});
        end
    end
end
