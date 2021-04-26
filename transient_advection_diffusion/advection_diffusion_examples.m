close all;

clear T_array u_array v_array;

tF = 15;
h = 2;
l = 2;
dt = 0.1;
dx = 0.1;
dy = 0.1;

Nx = l/dx;
Ny = h/dy;
Nt = tF/dt;


%% Test for advection only (upwind direction)

% Disable diffusion
alpha = 0;

% Some extra nodes for phantom nodes
u_array = zeros(Nx+2,Ny+1);
v_array = 0.1*ones(Nx+2,Ny+1);
T_array = zeros(Nx+2,Ny+1);
f_array = zeros(Nx+2,Ny+1);

% Preparation for plotting
h1 = figure;
axis off;
hold on;
title('Upwind Advection');

for k = 1 : Nt 
    T_array = apply_bc(T_array, dx, dy, ...
              ["Dirichlet", "Neumann", "Neumann", "Neumann"], [100, 0, 0, 0]);
          
    T_array = advection_diffusion_upwind(T_array, ...
                                         u_array, ...
                                         v_array, ...
                                         dt, ...
                                         dx, ...
                                         dy, ...
                                         alpha, ...
                                         f_array);
                                     
    heatmap(T_array, true);
    
    write2gif(h1, k, 'upwind_advection.gif');

end

%% Test for advection only (downwind direction)

clear T_array u_array v_array;

alpha = 0; % Disable diffusion

u_array = zeros(Nx,Ny);
v_array = -0.1*ones(Nx,Ny);
T_array = zeros(Nx,Ny);
f_array = zeros(Nx,Ny);

% Preparation for plotting
h2 = figure;
axis off;
hold on;
title('Downwind Advection');

heatmap(T_array, false)

for k = 1 : Nt 
    T_array = apply_bc(T_array, dx, dy, ...
              ["Neumann", "Dirichlet", "Neumann", "Neumann"], [0, 1000, 0, 0]);
          
    T_array = advection_diffusion_downwind(T_array, ...
                                         u_array, ...
                                         v_array, ...
                                         dt, ...
                                         dx, ...
                                         dy, ...
                                         alpha, ...
                                         f_array);
                                     
    heatmap(T_array, true);
    
    write2gif(h2, k, 'downwind_advection.gif');
end

%% Test for advection only (u and v are both non-zeros)

clear T_array u_array v_array;

alpha = 0; % Disable diffusion

u_array = 0.2*ones(Nx,Ny);
v_array = 0.2*ones(Nx,Ny);
T_array = zeros(Nx,Ny);
f_array = zeros(Nx,Ny);

% Preparation for plotting
h3 = figure;
axis off;
hold on;
title('Advection');

heatmap(T_array, true)

for k = 1 : Nt 
    T_array(1:4,1:4) = 200; % Bottom-left corner wall
    
    T_array = advection_diffusion_upwind(T_array, ...
                                         u_array, ...
                                         v_array, ...
                                         dt, ...
                                         dx, ...
                                         dy, ...
                                         alpha, ...
                                         f_array);
                                     
    heatmap(T_array, true);
    
    write2gif(h3, k, 'diagonal_upwind_advection.gif');
end

%% Test for diffusion only

clear T_array u_array v_array;

alpha = 0.02;

% Some extra nodes for phantom nodes
u_array = zeros(Nx+2,Ny+2); % Disable advection
v_array = zeros(Nx+2,Ny+2); % Disable advection
T_array = zeros(Nx+2,Ny+2); 
f_array = zeros(Nx+2,Ny+2);

% Preparation for plotting
h4 = figure;
axis off;
hold on;
title('Diffusion')

for k = 1 : Nt 
    
    % Heat source at the center of the plate, keep it true at all time
    T_array(Nx/2+1:Nx/2+2, Ny/2+1:Ny/2+2) = 300;
    T_array = apply_bc(T_array, dx, dy, ...
              ["Neumann", "Neumann", "Neumann", "Neumann"], [0, 0, 0, 0]);
    
    T_array = advection_diffusion_upwind(T_array, ...
                                         u_array, ...
                                         v_array, ...
                                         dt, ...
                                         dx, ...
                                         dy, ...
                                         alpha, ...
                                         f_array);
                                   
    heatmap(T_array, true);
    
    write2gif(h4, k, 'diffusion.gif');
end
