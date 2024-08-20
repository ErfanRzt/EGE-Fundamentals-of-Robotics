classdef PrismaticLink < Link
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    methods
        function P = PrismaticLink(theta, a, alpha, varargin)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            P = P@Link([theta, 0, a, alpha], 'type', 'prismatic', varargin{:});
        end
    end
end