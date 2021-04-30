close all;
clear all;
clc;

d_hc = 2.8;
d_ch = 2.5;
cp = 4187;
K = 660;
rho = 1000;
alpha = K/(rho*cp);

dx = 0.01;
dy = 0.01;
dt = 0.001; % Small enough to not cause instability

tF = 1000; % Simulation time, modify accordingly

ly = 2;     % 1x1 m^2
lx = 0.2;
Nx = (lx/dx+1) + 2;
Ny = (ly/dy+1) + 2;
Nt = tF/dt;

% Hot flow
uh_matrix = zeros(Nx,Ny); 
vh_matrix = 0.01*ones(Nx,Ny); 
Th_matrix = 300*ones(Nx,Ny); 
fh_matrix = zeros(Nx,Ny);

% Cold flow
uc_matrix = zeros(Nx,Ny); 
vc_matrix = -0.03*ones(Nx,Ny); 
Tc_matrix = 300*ones(Nx,Ny); 
fc_matrix = zeros(Nx,Ny);

% Initialize the velocity vectors
nu = 0.05;
dPh = -100;  % Negative pressure gradient, flowing from left to right
dPc = 150;   % Positive pressure gradient, flowing from right to left
vh_matrix = poiseuille_2d_flow(vh_matrix, lx, rho, nu, dPh, dx);
vc_matrix = poiseuille_2d_flow(vc_matrix, lx, rho, nu, dPc, dx);


% Preparation for plotting
hfig = figure;
hold on;
clims = [250 370];
im = imagesc([Th_matrix(2:end-1,2:end-1); Tc_matrix(2:end-1,2:end-1)], clims);
colormap(jet);
colorbar;
axis off;
title('Counter-Flow Heat Exchanger')

% Draw the separation line
plot([1 Ny-2],[Nx-2 Nx-2],'--k')

for k = 1 : Nt 
    
    % Heat source at the center of the plate, keep it true at all time
     Th_matrix = apply_bc(Th_matrix, dx, dy, ...
               ["Dirichlet", "Neumann", "Neumann", "Neumann"], ...
               [360, 0, 0, 0]);
           
    Tc_matrix = apply_bc(Tc_matrix, dx, dy, ...
               ["Neumann", "Dirichlet", "Neumann", "Neumann"], ...
               [0, 280, 0, 0]);
           
    % Calculate the forcing component
    fh_matrix(end-1,:) = -d_hc*(Th_matrix(end-1,:) - Tc_matrix(2,:));                      
    
    Th_matrix = advection_diffusion(Th_matrix, ...
                                  uh_matrix, ...
                                  vh_matrix, ...
                                  dt, ...
                                  dx, ...
                                  dy, ...
                                  alpha, ...
                                  fh_matrix);
                              
   fc_matrix(2,:) = -d_ch*(Tc_matrix(2,:) - Th_matrix(end-1,:));
                              
   Tc_matrix = advection_diffusion(Tc_matrix, ...
                                  uc_matrix, ...
                                  vc_matrix, ...
                                  dt, ...
                                  dx, ...
                                  dy, ...
                                  alpha, ...
                                  fc_matrix);
    if mod(k-1,10000) == 0
        im.CData = [Th_matrix(2:end-1,2:end-1); ...
                    Tc_matrix(2:end-1,2:end-1)];
        drawnow
        write2gif(hfig, k, 'heat_exchanger.gif');
    end
end

