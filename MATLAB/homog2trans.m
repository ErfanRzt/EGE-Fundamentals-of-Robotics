function translationVector = homog2trans(homogMatrix)
% homog2trans Extracts the translation vector from a homogeneous transformation matrix.
% 
% Inputs:
%   homogMatrix - A 4x4 homogeneous transformation matrix.
%                  The matrix should have the form:
%                  [ R, t;
%                    0, 1 ]
%                  where R is a 3x3 rotation matrix and t is a 3x1 translation vector.
%
% Outputs:
%   translationVector - A 3x1 vector representing the translation component extracted from the input matrix.
%
% Example:
%   H = [eye(3), [1; 2; 3]; 0, 0, 0, 1];    % Example homogeneous matrix
%   t = homog2trans(H);                     % Returns [1; 2; 3]

% Extract the translation vector from the last column of the matrix
translationVector = homogMatrix(1:3, 4);
end
