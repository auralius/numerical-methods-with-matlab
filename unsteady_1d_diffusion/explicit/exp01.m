% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L into Nx segments
% Divide 0<=t<=tF into Nt segments
% f(x) is the initial condition

close all
clear all
clc

L = 10;
alpha = sqrt(1.14);

tF = 20;
Nx = 10;
Nt = 1000;

u_array = zeros(1,Nx+1); % +1 because we start from 0 to Nx
g_array = zeros(1,Nx+1);
u_array = apply_ic(u_array,@f, L/Nx);

hf = figure;
hold on
h = plot(0,0,'-*');
ylim([0 70])

x = 0 : Nx;

for k = 1 : Nt
    set(h, 'XData', x, 'YData', u_array)
    drawnow;
    write2gif(hf, k, 'exp01.gif');
    
    u_array = apply_bc(u_array, L/Nx, ["Dirichlet", "Dirichlet"], [0, 0]);   
    u_array = diffusion_solver(u_array, g_array, alpha, L/Nx, tF/Nt);
end
xlabel('n-th segment')
ylabel('u(x,t)')

%%
function u=f(x)
L = 10;
u = zeros(1,length(x));

for k = 1 : length(x)
    if x(k) >= 0 && x(k) <=L/2
        u(k) = 60;
    elseif x(k) > L/2 && x(k) <= L
        u(k) = 0;
    end
end

end