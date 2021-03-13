% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L into Nx segments
% Divide 0<=t<=tF into Nt segments
% f(x) is the initial condition

close all
clear all
clc

L = pi;
alpha = 1;

tF = 20;
Nx = 10;
Nt = 1000;

u_array = zeros(1,Nx+1+1); % +1 -> start from 0 to Nx
                           % another +1 -> add one phantom point
u_array = apply_ic(u_array,@f, L/Nx);
g_array = zeros(1,length(u_array));


figure
hold on
h = plot(0,0,'-*');
ylim([0 70])

x = 0 : Nx+1;

for k = 1 : Nt
    set(h, 'XData', x, 'YData', u_array)
    drawnow;
    
    u_array = apply_bc(u_array, L/Nx, ["Dirichlet", "Neumann"], [20, 3]);
    u_array = diffusion_1d(u_array, g_array, alpha, L/Nx, tF/Nt);
end
xlabel('n-th segment')
ylabel('u(x,t)')

%%
function u=f(x)
    u = zeros(1,length(x));
end