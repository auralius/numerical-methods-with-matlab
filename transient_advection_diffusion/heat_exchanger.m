close all;
clear all;
clc;

tF = 1000; % Simulation time, modify accordingly

% Made-up numbers
h_H = 2.8;
h_C = 2.5;

% Water properties
cp = 4187;
K = 660;
rho = 1000;
alpha = K/(rho*cp);

dx = 0.01;
dy = 0.01;
dt = 0.001; % Small enough to not cause instability

lx = 2;
ly = 0.2;  % 2 x 0.2 

Nx = (lx/dx+1) + 2;
Ny = (ly/dy+1) + 2;
Nt = tF/dt;

% Hot flow
uh_matrix = zeros(Ny,Nx); 
vh_matrix = 0.01*ones(Ny,Nx); 
Th_matrix = 300*ones(Ny,Nx); 
fh_matrix = zeros(Ny,Nx);

% Cold flow
uc_matrix = zeros(Ny,Nx); 
vc_matrix = -0.03*ones(Ny,Nx); 
Tc_matrix = 300*ones(Ny,Nx); 
fc_matrix = zeros(Ny,Nx);

% Initialize the velocity vectors
nu = 0.05;
dPh = -100;  % Negative pressure gradient, flowing from left to right
dPc = 150;   % Positive pressure gradient, flowing from right to left
vh_matrix = poiseuille_2d_flow(vh_matrix, ly, rho, nu, dPh, dy);
vc_matrix = poiseuille_2d_flow(vc_matrix, ly, rho, nu, dPc, dy);


% Preparation for plotting
hfig = figure;
hold on;
clims = [250 370];
im = imagesc([Th_matrix(2:end-1,2:end-1); Tc_matrix(2:end-1,2:end-1)], clims);
colormap(jet);
colorbar;
axis off equal;
title('Counter-Flow Heat Exchanger')

htext = text(Nx/2,-2, 'Time=');
htext.FontWeight = 'bold';

% Draw the separation line
plot([1 Nx-2],[Ny-2 Ny-2],'--k')

for k = 1 : Nt 
    
    % Heat source at the center of the plate, keep it true at all time
     Th_matrix = apply_bc(Th_matrix, dx, dy, ...
               ["Dirichlet", "Neumann", "Neumann", "Neumann"], ...
               [360, 0, 0, 0]);
           
    Tc_matrix = apply_bc(Tc_matrix, dx, dy, ...
               ["Neumann", "Dirichlet", "Neumann", "Neumann"], ...
               [0, 280, 0, 0]);
           
    % Calculate the forcing component
    fh_matrix(end-1,:) = -h_H*(Th_matrix(end-1,:) - Tc_matrix(2,:));                      
    
    Th_matrix = advection_diffusion(Th_matrix, ...
                                  uh_matrix, ...
                                  vh_matrix, ...
                                  dt, ...
                                  dx, ...
                                  dy, ...
                                  alpha, ...
                                  fh_matrix);
                              
   fc_matrix(2,:) = -h_C*(Tc_matrix(2,:) - Th_matrix(end-1,:));
                              
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
        htext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig, k, 'heat_exchanger.gif');
    end
end

