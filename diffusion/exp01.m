% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L into Nx segments
% Divide 0<=t<=tF into Nt segments
% p(t) is the left boundary conditoin
% q(t) is the right boundary condition
% f(x) is the initial condition

close all
clear all
clc

p = @(t) 10+100*t;
q = @(t) 50;
f = @(x) 20*x;

L = 1;
alpha = 1;

tF = 1;   
Nx = 4;
Nt = 100;

U = diffusion_1d(alpha, p, q, f, L, Nx, Nt, tF);

figure
hold on
h = plot(0,0);
ylim([0 150])

x = 0 : Nx;

for k = 1 : Nt
    set(h, 'XData', x, 'YData', U(:,k))
    drawnow;
end
xlabel('n-th segment')
ylabel('u(x,t)')