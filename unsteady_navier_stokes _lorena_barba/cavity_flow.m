clear 
clc
close all

Lx = 2;
Ly = 2;

dx = 0.1;
dy = 0.1;

dt = 0.01;

rho = 1.0;
nu = 0.1;

nx = ceil(Lx/dx);
ny = ceil(Ly/dy);

p = zeros(nx,ny);
u = zeros(nx,ny);
v = zeros(nx,ny);

% The order of the boundaries: left, right, top, bottom
pressure_bc_types = ["neumann", "neumann", "dirichlet", "neumann"];
pressure_bc_values = [0, 0, 0, 0];

u_bc_types =  ["dirichlet", "dirichlet", "dirichlet", "dirichlet"];
u_bc_values = [0, 0, 1, 0];

v_bc_types =  ["dirichlet", "dirichlet", "dirichlet", "dirichlet"];
v_bc_values = [0, 0, 0, 0];


for k = 1 : 1000
    [u,v,p] = ns_solver_2d(u, ...
                           v, ...
                           p, ...
                           nx, ...
                           ny, ...
                           dx, ...
                           dy, ...
                           dt, ...
                           rho, ...
                           nu, ...
                           pressure_bc_types, ...
                           pressure_bc_values, ...
                           u_bc_types, ...
                           u_bc_values, ...
                           v_bc_types, ...
                           v_bc_values);

   contourf(u,10)
   drawnow
end
