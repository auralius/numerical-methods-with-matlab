clear all
clc
close all

Lx = 1;
Ly = 1;

dx = 1/100;
dy = 1/100;

dt = 0.001;

rho = 1.0;
nu = 1/100;

delta = 10;

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



[u,v,p,E] = ns_solver_2d(u, ...
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
    v_bc_values, ...
    delta);

