classdef RevoluteLink < Link
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    methods
        function R = RevoluteLink(d, a, alpha, varargin)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            R = R@Link([0, d, a, alpha], 'type', 'revolute', varargin{:});
        end
    end
end