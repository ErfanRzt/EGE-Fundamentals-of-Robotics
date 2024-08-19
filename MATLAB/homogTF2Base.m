function baseTransforms = homogTF2Base(homogTransforms)
    % HOMOGTF2BASE Computes the homogeneous transformation matrices from the base frame to each joint.
    %
    %   baseTransforms = homogTF2Base(homogTransforms) calculates the cumulative homogeneous 
    %   transformation matrices from the base frame to each joint given a cell array of 
    %   homogeneous transformation matrices between consecutive joints.
    %
    %   Input:
    %   - homogTransforms: A 1 x n cell array, where each cell contains a 4x4 homogeneous 
    %     transformation matrix representing the transformation from joint i-1 to joint i.
    %
    %   Output:
    %   - baseTransforms: A 1 x n cell array, where each cell contains a 4x4 homogeneous 
    %     transformation matrix representing the transformation from the base frame to joint i.
    %
    %   Example:
    %   % Given a cell array of joint transformations
    %   baseFrameTransforms = homogTF2Base(homogTransforms);

    % Determine the number of joints from the input cell array
    nJoints = numel(homogTransforms);
    
    % Preallocate a cell array to store the transformation matrices to the base frame
    baseTransforms = cell(nJoints, 1);
    
    % Initialize the cumulative product of transformation matrices with the identity matrix
    productTF = eye(4);
    
    % Loop through each joint to compute the transformation from the base frame
    for i = 1:nJoints
        % Multiply the current cumulative transformation matrix with the transformation 
        % matrix from the current joint to the next joint
        baseTransforms{i} = productTF * cell2mat(homogTransforms(i));
        
        % Update the cumulative transformation matrix for the next iteration
        productTF = baseTransforms{i};
    end
end
