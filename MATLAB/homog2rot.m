function rotationMatrix = homog2rot(homogMatrix)
% homog2rot Extracts the rotation matrix from a homogeneous transformation matrix.
% 
% Inputs:
%   homogMatrix - A 4x4 homogeneous transformation matrix.
%                  The matrix should have the form:
%                  [ R, t;
%                    0, 1 ]
%                  where R is a 3x3 rotation matrix and t is a 3x1 translation vector.
%
% Outputs:
%   rotationMatrix - A 3x3 matrix representing the rotation component extracted from the input matrix.
%
% Example:
%   H = [eye(3), [1; 2; 3]; 0, 0, 0, 1];    % Example homogeneous matrix
%   R = homog2rot(H);                       % Returns eye(3)

% Extract the rotation matrix from the top-left 3x3 submatrix of the input matrix
rotationMatrix = homogMatrix(1:3, 1:3);
end
