function [homogMatrix] = rt2homog(rotationMatrix, translationVector)
    % RT2HOMOG Converts rotation matrix and translation vector to a homogeneous transformation matrix.
    % 
    % Inputs:
    %   rotationMatrix - A 3x3 matrix representing the rotation component of the transformation.
    %   translationVector - A 3x1 vector representing the translation component of the transformation.
    %
    % Outputs:
    %   homogMatrix - A 4x4 homogeneous transformation matrix combining the rotation and translation.
    %
    % Example:
    %   R = eye(3);         % 3x3 identity matrix
    %   t = [1; 2; 3];      % Translation vector
    %   H = rt2homog(R, t); % Returns a 4x4 homogeneous matrix
    
    homogMatrix = [ rotationMatrix, translationVector   ;
                         0,  0,  0,                 1   ];
end