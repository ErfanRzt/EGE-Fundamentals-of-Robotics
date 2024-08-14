classdef Link
    properties
        theta  % Joint angle (for revolute joints)
        d      % Link offset (for prismatic joints)
        a      % Link length
        alpha  % Link twist
    end
    
    methods
        function obj = Link(theta, d, a, alpha)
            % Constructor to initialize the DH parameters
            if nargin > 0
                obj.theta = theta;
                obj.d = d;
                obj.a = a;
                obj.alpha = alpha;
            end
        end
        
        function disp(obj)
            % Display function to show DH parameters
            fprintf('DH Parameters:\n---\n');
            fprintf('Theta: \t%6.3f\n', obj.theta);
            fprintf('d: \t\t%6.3f\n', obj.d);
            fprintf('a: \t\t%6.3f\n', obj.a);
            fprintf('alpha: \t%6.3f\n', obj.alpha);
        end
    end
end
