function homogTransforms = dhTransforms(dhParams)
    % DHTRANSFORMS Compute homogeneous transformation matrices from DH parameters.
    %
    %   homogTransforms = dhTransforms(dhParams) takes a matrix dhParams of Denavit-Hartenberg
    %   parameters and returns a cell array homogTransforms where each element is a 
    %   homogeneous transformation matrix between consecutive joints.
    %
    %   Input:
    %   - dhParams: An n x 4 matrix containing the DH parameters, where each row represents 
    %     [theta, d, a, alpha] for a single joint.
    %
    %   Output:
    %   - homogTransforms: A 1 x n cell array of 4x4 homogeneous transformation matrices.
    %
    %   Example:
    %   dhParams = [pi/2, 0, 1, pi/2; 0, 1, 1, 0];
    %   transforms = dhTransforms(dhParams);

    % Number of joints
    nJoints = size(dhParams, 1);
    
    % Preallocate the cell array for transformation matrices
    homogTransforms = cell(1, nJoints);
    
    % Compute each transformation matrix
    for i = 1:nJoints
        theta = dhParams(i, 1);  % Joint angle
        d = dhParams(i, 2);      % Link offset
        a = dhParams(i, 3);      % Link length
        alpha = dhParams(i, 4);  % Link twist angle
        
        % Homogeneous transformation matrix from joint i-1 to joint i
        homogTransforms{i} = ...
        [   cos(theta), -sin(theta)*cos(alpha),  sin(theta)*sin(alpha), a*cos(theta);
            sin(theta),  cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
                     0,             sin(alpha),             cos(alpha),            d;
                     0,                      0,                      0,            1];
    end
end
