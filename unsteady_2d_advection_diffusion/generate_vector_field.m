% This function generates a vector field of f(i,j) = c_x*x + c_y*y.
% It returns a matrix of n_row x n_col.
% d_row and d_col describe the step distance. They are used to convert row
% and column into actulal x and y.

function  [X,Y] = generate_vector_field(c_x, c_y, Nx, Ny, dx, dy)

mid_x = Nx/2*dx;
mid_y = Ny/2*dy;

[X, Y] = meshgrid([0:dy:(Ny-1)*dy]-mid_y, [0:dx:(Nx-1)*dx]-mid_x);

X = c_x * X;
Y = c_y * Y;

end