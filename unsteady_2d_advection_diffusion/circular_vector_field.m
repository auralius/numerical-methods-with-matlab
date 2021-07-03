close all;
clear all;
clc;

tF = 3;         % Simulation time, modify accordingly

lx = 2;         % The dimension
ly = 2;

dt = 0.001;
dx = 0.1;
dy = 0.1;

Nx = lx/dx+1+2;
Ny = ly/dy+1+2;
Nt = tF/dt;

% Diffusion
alpha = 0.2;

% Some extra nodes for phantom nodes
T_matrix = 270*ones(Ny, Nx);
f_matrix = zeros(Ny, Nx);

% Initialize u and v
[u_matrix,v_matrix] = generate_vector_field(-4, 4 , Nx, Ny, dx, dy);

% Preparation for plotting
hfig = figure;
hold on;
clims = [200 1000];
im = imagesc(T_matrix(2:end-1,2:end-1), clims);
colormap(jet);
colorbar;
axis off equal;

htext = text(Nx/2,-1, 'Time=');
htext.FontWeight = 'bold';

% Flip u and v when plotting
quiver(v_matrix(2:end-1,2:end-1), u_matrix(2:end-1,2:end-1), 'k');

for k = 1 : Nt
    T_matrix(5,10) = 1000;
    
    T_matrix = apply_bc(T_matrix, dx, dy, ...
        ["Neumann", "Neumann", "Neumann", "Neumann"], [0, 0, 0, 0]);
    
    T_matrix = advection_diffusion_solver(T_matrix, ...
        u_matrix, ...
        v_matrix, ...
        dt, ...
        dx, ...
        dy, ...
        alpha, ...
        f_matrix);
    
    if mod(k-1,10) == 0
        im.CData = T_matrix(2:end-1,2:end-1);
        htext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig, k, 'advection_diffusion_circular_vector_field.gif');
    end
    
end


