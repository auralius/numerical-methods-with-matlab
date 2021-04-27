% Countercurrent Double-Pipe Heat Exchanger 
% https://www.maplesoft.com/applications/view.aspx?SID=119402&view=html

clear all;
close all;
clc;

L = 1;

tF = 5;
Nx = 10;
Nt = 100;

dt = tF/Nt;
dx = L/Nx;

v1 = 0.6366197724;
v2 = 0.1657863990;
v3 = 0.00003585526318;
d1 = 0.9792;
d2 = 0.2986;
d3 = 2.3923;
d4 = 2.8708;

TH = zeros(1, Nx+1);
TC = zeros(1, Nx+1);
TW = zeros(1, Nx+1+2);  % +2 phantom nodes

fH = zeros(1, Nx+1);
fC = zeros(1, Nx+1);
fW = zeros(1, Nx+1+2);  % +2 phantom nodes

% Intial condition
TH(1:Nx+1) = 360;
TC(1:Nx+1) = 300;
TW(1:Nx+1+2) = 330;

h=figure;
hold on
h1 = plot(0,0,'r-*');
h2 = plot(0,0,'b-*');
h3 = plot(0,0,'m-*');
title('Cross-current heat exchanger')
ylim([270 400])
xlabel('x')
ylabel('Temperature')
legend('Hot flow', 'Cold flow', 'Wall')

xa = 1:Nx+1; % for advection
xb = 0:Nx+2; % for diffusion
for k = 1 : Nt
    set(h1,'XData',xa,'Ydata',TH);
    set(h2,'XData',xa,'Ydata',TC);
    set(h3,'XData',xb,'Ydata',TW);
    drawnow;
    
    write2gif(h, k, 'exp01.gif');
    
    TW = apply_bc(TW, L/Nx, ["Neumann", "Neumann"], [0, 0]);  
    
    % TW(2:end-1) : it means we ignore phantom nodes
    
    fH = -d1.*(TH-TW(2:end-1));
    TH = upwind(TH, fH, v1, dt, dx);
    
    fC = d2.*(TH-TW(2:end-1));
    TC = downwind(TC, fC, -v2, dt, dx);
    
    fW(2:end-1) = d3.*(TH-TW(2:end-1)) - d4.*(TW(2:end-1)-TC);
    TW = diffusion_1d(TW, fW, sqrt(v3), dx, dt);
end
