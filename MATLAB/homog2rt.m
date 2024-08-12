function [R, t] = homog2rt(homogMatrix)
% homog2rt Extracts the rotation matrix and translation vector from a homogeneous transformation matrix.
% 
% Inputs:
%   homogMatrix - A 4x4 homogeneous transformation matrix.
%                  The matrix should have the form:
%                  [ R, t;
%                    0, 1 ]
%                  where R is a 3x3 rotation matrix and t is a 3x1 translation vector.
%
% Outputs:
%   R - A 3x3 matrix representing the rotation component extracted from the input matrix.
%   t - A 3x1 vector representing the translation component extracted from the input matrix.
%
% Example:
%   H = [eye(3), [1; 2; 3]; 0, 0, 0, 1];    % Example homogeneous matrix
%   [R, t] = homog2rt(H);                   % Returns R = eye(3) and t = [1; 2; 3]

% Extract the rotation matrix 
% from the top-left 3x3 submatrix of the input matrix
R = homogMatrix(1:3, 1:3);

% Extract the translation vector 
% from the last column of the top 3 rows of the matrix
t = homogMatrix(1:3, 4);
end
