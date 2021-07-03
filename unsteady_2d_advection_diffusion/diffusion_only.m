% Test for diffusion only

clear all
close all
clc

tF = 10;  % Simulation time, modify accordingly

h = 2;
l = 2;
dt = 0.001;
dx = 0.1;
dy = 0.1;

Nx = l/dx;
Ny = h/dy;
Nt = tF/dt;

alpha = 0.1; % Diffusity parameter

% Some extra nodes for phantom nodes
u_array = zeros(Ny+2,Nx+2); % Disable advection
v_array = zeros(Ny+2,Nx+2); % Disable advection
T_array = 270*ones(Ny+2,Nx+2);
f_array = zeros(Ny+2,Nx+2);

% Preparation for plotting
hfig = figure;
hold on;
clims = [250 850];
im = imagesc( T_array(2:end-1,2:end-1), clims);
colormap(jet);
colorbar;
axis off equal;
title('Diffusion Only')

htext = text(Nx/2, 0, 'Time=');
htext.FontWeight = 'bold';

for k = 1 : Nt
    
    % Heat source at the center of the plate, keep it true at all time
    T_array(Ny/2+1:Ny/2+2, Nx/2+1:Nx/2+2) = 800;
    T_array = apply_bc(T_array, dx, dy, ...
        ["Neumann", "Neumann", "Neumann", "Neumann"], [0, 0, 0, 0]);
    
    T_array = advection_diffusion_solver(T_array, ...
        u_array, ...
        v_array, ...
        dt, ...
        dx, ...
        dy, ...
        alpha, ...
        f_array);
    
    if mod(k-1,100) == 0
        im.CData = T_array(2:end-1,2:end-1);
        htext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow;
        write2gif(hfig, k, 'diffusion_only.gif');
    end
end