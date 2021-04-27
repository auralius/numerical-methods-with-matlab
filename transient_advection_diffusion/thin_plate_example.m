close all;

dz = 0.01;
cp = 385;
K = 400;
rho = 8960;
alpha = K/(rho*cp);
beta = dz*rho*cp;

dx = 0.01;
dy = 0.01;
dt = 0.001; % Small enough to not cause instability

ly = 1;     % 1x1 m^2
lx = 1;
Nx = lx/dx;
Ny = ly/dy;
Nt = tF/dt;

tF = 10000; % Simulation time, modify accordingly

h = 10;
sigma = 5.67e-8;
e = 0.5;
T_inf = 300;

clear T_array u_array v_array f_array;

% Some extra nodes for phantom nodes
u_array = zeros(Nx+2,Ny+1); % Disable advection
v_array = zeros(Nx+2,Ny+1); % Disable advection
T_array = 297.15*ones(Nx+2,Ny+1); 
f_array = zeros(Nx+2,Ny+1);

% Preparation for plotting
hfig = figure;
axis off;
hold on;
title('Diffusion')
caxis([300 800])

for k = 1 : Nt 
    
    % Heat source at the center of the plate, keep it true at all time
    T_array = apply_bc(T_array, dx, dy, ...
              ["Dirichlet", "Neumann", "Neumann", "Neumann"], ...
              [800, 0, 0, 0]);

    % Calculate the forcing component
    f_array(2:end-1,2:end-1) = -(2*h/beta*(T_array(2:end-1,2:end-1) - T_inf) ...
                      + 2*e*sigma/beta*(T_array(2:end-1,2:end-1).^4 - T_inf^4));      
                  
    T_array = advection_diffusion_upwind(T_array, ...
                                         u_array, ...
                                         v_array, ...
                                         dt, ...
                                         dx, ...
                                         dy, ...
                                         alpha, ...
                                         f_array);
                                   
    %heatmap(T_array, false);
    
    %write2gif(hfig, k, 'thinplate.gif');
end

heatmap(T_array, false);
