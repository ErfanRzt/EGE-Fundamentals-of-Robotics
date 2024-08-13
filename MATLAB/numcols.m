function nCols = numcols(A)
%NUMCOLS Returns the number of columns in the matrix A
%   nCols = NUMCOLS(A) takes a matrix A as input and returns the number of
%   columns in A. The function uses the size function to determine the number
%   of columns, which is the second dimension of the matrix.

    % Determine the number of columns in matrix A using the size function.
    nCols = size(A, 2);

end
