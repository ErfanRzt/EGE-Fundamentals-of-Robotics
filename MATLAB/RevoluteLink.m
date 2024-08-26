classdef RevoluteLink < Link
    methods
        function obj = RevoluteLink(d, a, alpha, offset, varargin)
            % REVOLUTELINK Construct an instance of this class.
            %
            % Syntax:
            %   obj = RevoluteLink(d, a, alpha, offset)
            %   obj = RevoluteLink(d, a, alpha, offset, 'PropertyName', PropertyValue, ...)
            %
            % Description:
            %   Creates a RevoluteLink object using specified Denavit-Hartenberg (DH) 
            %   parameters for a revolute joint along with optional dynamic properties.
            %
            % Input Arguments:
            %   d       - [scalar] Link perpendicular distance
            %   a       - [scalar] Link length
            %   alpha   - [scalar] Link twist
            %   offset  - [scalar] Joint rotation angle offset
            %
            %   Name-Value Pair Arguments:
            %     'Name'    - [char or string]  Name of the link (default: 'NewLink').
            %   * 'Type'    - [char or string]  (WARNING) DO NOT MODIFY! Filled internally as 'Revolute'.
            %     'qlim'    - [1x2 array]       Joint limits [min, max] (default: [-inf, inf]).
            %     'm'       - [scalar]          Mass of the link (default: 0).
            %     'r'       - [3x1 vector]      Center of mass (default: [0; 0; 0]).
            %     'I'       - [3x3 matrix]      Inertia tensor (default: zeros(3,3)).
            %
            % Output:
            %   obj     - Instance of the RevoluteLink class.
            
            dhparameters = [offset, d, a, alpha];
            obj = obj@Link(dhparameters, 'type', 'Revolute', varargin{:});
        end
    end
end
