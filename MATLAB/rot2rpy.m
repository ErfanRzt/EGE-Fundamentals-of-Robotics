function [T, alpha, beta, gamma] = rot2rpy(R)    
    % Extract the elements of the rotation matrix
    r11 = R(1, 1);
    r21 = R(2, 1);
    r31 = R(3, 1);
    r32 = R(3, 2);
    r33 = R(3, 3);
    
    % Calculate the Pitch (beta)
    beta = atan2(-r31, sqrt(r11^2 + r21^2));
    
    % Handle representation singularity at beta = ±pi/2
    if abs(cos(beta)) < 1e-6
        warning('SETTING T TO A SINGULAR CONFIGURATION!');
        alpha = 0;                          % Set Roll to 0
        gamma = atan2(R(2, 3), R(1, 3));    % Yaw angle
    else
        % Calculate Roll (alpha) and Yaw (gamma)
        alpha = atan2(r32, r33);
        gamma = atan2(r21, r11);
    end
    
    % Construct the transformation matrix T
    T = [1,           0,              -sin(beta) ; ...
         0,  cos(alpha),  sin(alpha) * cos(beta) ; ...
         0, -sin(alpha),  cos(alpha) * cos(beta) ];
end
