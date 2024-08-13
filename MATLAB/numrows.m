function nRows = numrows(A)
%NUMROWS Returns the number of rows in the matrix A
%   nRows = NUMROWS(A) takes a matrix A as input and returns the number of
%   rows in A. The function uses the size function to determine the number
%   of rows, which is the first dimension of the matrix.

    % Determine the number of rows in matrix A using the size function.
    nRows = size(A, 1);

end
