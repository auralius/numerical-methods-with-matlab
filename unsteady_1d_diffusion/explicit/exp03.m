% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L into Nx segments
% Divide 0<=t<=tF into Nt segments
% f(x) is the initial condition

close all
clear all
clc

L = 1;
alpha = 1;

tF = 1;
Nx = 10;
Nt = 1000;

u_array = zeros(1,Nx+1+1); % +1 because we start from 0 to Nx
                           % another +1 -> add one phantom nodes
g_array = zeros(1,length(u_array));
u_array = apply_ic(u_array,@f, L/Nx);

hf = figure;
hold on
h = plot(0,0,'-*');
ylim([0 105])
xlabel('n-th segment')
ylabel('u(x,t)')

x = 0 : Nx+1;

for k = 1 : Nt
    set(h, 'XData', x, 'YData', u_array)
    drawnow;
    write2gif(hf, k, 'exp03.gif'); 
    
    u_array = apply_bc(u_array, L/Nx, ["Neumann", "Dirichlet"], [0, 100]);   
    u_array = diffusion_solver(u_array, g_array, alpha, L/Nx, tF/Nt);
end

%%
function u=f(x)
L = 1;
u = zeros(1,length(x));

for k = 2 : length(x) % first node is a phantom node
    if x(k) >= 0 && x(k) <=L/2
        u(k) = 60;
    elseif x(k) > L/2 && x(k) <= L
        u(k) = 0;
    end
end

end