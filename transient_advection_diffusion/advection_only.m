% Test for advection only (u and v are both non-zeros resulting in diagonal
% movement

clear all;
close all;
clc;

tF = 20;  % Simulation time, modify accordingly

h = 1;    
l = 1;
dt = 0.001;
dx = 0.01;
dy = 0.01;

Nx = l/dx;
Ny = h/dy;
Nt = tF/dt;

alpha = 0; % Disable diffusion

u_array = 0.2*ones(Ny,Nx);
v_array = 0.2*ones(Ny,Nx);
T_array = 270*ones(Ny,Nx);
f_array = zeros(Ny,Nx);

% Preparation for plotting
hfig = figure;
hold on
clims = [250 850];
im = imagesc( T_array, clims);
colormap(jet);
colorbar;
axis off equal;
hold on;
title('Advection Only');

htext = text(Nx/2, -1, 'Time=');
htext.FontWeight = 'bold';

for k = 1 : Nt
    T_array = apply_bc(T_array, dx, dy, ...
        ["Dirichlet", "Dirichlet", "Dirichlet", "Dirichlet"], ...
        [270, 270, 270, 270]);
    
    T_array(1:10,1:10) = 800; % Bottom-left corner wall
    
    T_array = advection_diffusion(T_array, ...
        u_array, ...
        v_array, ...
        dt, ...
        dx, ...
        dy, ...
        alpha, ...
        f_array);
    
    if mod(k-1,1000) == 0
        im.CData = T_array;
        htext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow;
        write2gif(hfig, k, 'advection_only.gif');
    end
end