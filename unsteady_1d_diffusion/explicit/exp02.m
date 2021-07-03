% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L into Nx segments
% Divide 0<=t<=tF into Nt segments
% f(x) is the initial condition

close all
clear all
clc

L = pi;
alpha = 1;

tF = 10;
Nx = 10;
Nt = 1000;

u_array = zeros(1,Nx+1+1); % +1 -> start from 0 to Nx
                           % another +1 -> add one phantom point
g_array = zeros(1,length(u_array));
u_array = apply_ic(u_array,@f, L/Nx);

hf = figure;
hold on
h = plot(0,0,'-*');
ylim([0 32])
xlabel('n-th segment')
ylabel('u(x,t)')

x = 0 : Nx+1;

for k = 1 : Nt
    set(h, 'XData', x, 'YData', u_array)
    drawnow;
    write2gif(hf, k, 'exp02.gif');
    
    u_array = apply_bc(u_array, L/Nx, ["Dirichlet", "Neumann"], [20, 3]);
    u_array = diffusion_solver(u_array, g_array, alpha, L/Nx, tF/Nt);
end

%%
function u=f(x)
    u = zeros(1,length(x));
end