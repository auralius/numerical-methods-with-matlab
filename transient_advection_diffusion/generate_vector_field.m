% This function generates a vector field of f(i,j) = c_row*i + c_col*j.
% It returns a matrix of n_row x n_col.
% d_row and d_col describe the step distance. They are used to convert row
% and column into actulal x and y.

function  [U,V] = generate_vector_field(c_row,c_col,n_row,n_col,d_row,d_col)

mid_r = n_row/2*d_row;
mid_c = n_col/2*d_col;

[R,C] = meshgrid([0:d_row:(n_row-1)*d_row]-mid_r, [0:d_col:(n_col-1)*d_col]-mid_c);

U = c_row * R;
V = c_col * C;

end