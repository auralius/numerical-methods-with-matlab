% https://www.comsol.com/model/out-of-plane-heat-transfer-for-a-thin-plate-493

close all;
clear all;
clc;

tF = 500;             % Simulation time, modify accordingly

dz = 0.01;
cp = 385;
K = 400;
rho = 8960;
alpha = K/(rho*cp);
beta = dz*rho*cp;

dx = 0.01;
dy = 0.01;
dt = 0.001;           % Small enough to not cause instability

ly = 1;               % 1x1 m^2
lx = 1;
Nx = lx/dx+1;         % +1, because we start from 0 to Nx
Ny = ly/dy+1;         % +1, because we start from 0 to Ny
Nt = tF/dt;

h = 10;
sigma = 5.67e-8;
e = 0.5;
T_inf = 300;

% Some extra nodes for phantom nodes
u_array = zeros(Ny+2,Nx+1);       % No advection
v_array = zeros(Ny+2,Nx+1);       % No advection
T_array = 297.15*ones(Ny+2,Nx+1); % Initial condition
f_array = zeros(Ny+2,Nx+1);       % No external forcing component

% Preparation for plotting
hfig = figure;
hold on;

clims = [300 800];
im = imagesc(T_array(2:end-1,1:end-1), clims);
colormap(jet);
colorbar;

htext = text(Nx/2,-2, 'Time=');
htext.FontWeight = 'bold';

axis off equal;
title('Thin Plate');

for k = 1 : Nt
    
    % Heat source at left-edge of the plate, keep it true at all time
    T_array = apply_bc(T_array, dx, dy, ...
        ["Dirichlet", "Neumann", "Neumann", "Neumann"], ...
        [800, 0, 0, 0]);
    
    % Calculate the forcing component
    f_array(2:end-1,2:end-1) = -(2*h/beta*(T_array(2:end-1,2:end-1) - T_inf) ...
        + 2*e*sigma/beta*(T_array(2:end-1,2:end-1).^4 - T_inf^4));
    
    T_array = advection_diffusion_solver(T_array, ...
        u_array, ...
        v_array, ...
        dt, ...
        dx, ...
        dy, ...
        alpha, ...
        f_array);
    
    if mod(k-1,10000) == 0
        im.CData = T_array(2:end-1,1:end-1);
        htext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow;
        write2gif(hfig, k, 'thinplate.gif');
    end
end