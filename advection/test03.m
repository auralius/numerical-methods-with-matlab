clc
clear all
close all

clc
clear all
close all

L = 10;
dx = 0.05;
x = 0:dx:L;

dt = 0.05;
T = 20;
t = 0:dt:T;

u = zeros(length(x), 1);
f = zeros(length(x), 1);

%% ------------------------------------------------------------
c = 0.5; % moving to right

for k = 1:length(x)
    u(k) = exp(-10*(x(k)-2).^2);
end

figure;
h1 = plot(0,0);
title('Lax-Wendroff, moving to the right c = 0.5')
ylim([0 1]);

for k = 1:length(t)
    u = lax_wendroff(u,f, c, dt, dx);
    set(h1,'XData',x,'Ydata',u);
    drawnow
end

%% ------------------------------------------------------------
c = -0.5; % moving to left

for k = 1:length(x)
    u(k) = exp(-10*(x(k)-8).^2);
end

figure;
h1 = plot(0,0);
title('Lax-Wendroff, moving to the left, c = -0.5')
ylim([0 1]);

for k = 1:length(t)
    u = lax_wendroff(u,f, c, dt, dx);
    set(h1,'XData',x,'Ydata',u);
    drawnow
end
%% Test system of PDE: cross-current heat exchanger

% [1] F. Zobiri, E. Witrant, and F. Bonne, “PDE Observer Design for 
% Counter-Current Heat Flows in a Heat-Exchanger,” IFAC-PapersOnLine, vol. 
% 50, no. 1, pp. 7127–7132, 2017.

clear u x;

L = 1;
dx = 0.05;
x = 0:dx:L;

dt = 0.01;
T = 20; % This takes some time
t = 0:dt:T;

c1 = 0.001711593407;
c2 = -0.01785371429;
d1 = -0.03802197802;
d2 = 0.3954285714;

N = length(x);
TH = zeros(N,1);
TC = zeros(N,1);
f = zeros(N,1);

% Intial conditoin
for k = 1:N
    TH(k) = 273+30;
    TC(k) = 273+10;
end

figure;
hold on
h3 = plot(0,0,'r');
h4 = plot(0,0,'b');
title('Cross-current heat exchanger')
ylim([270 320])
xlabel('x')
ylabel('Temperature')
legend('Hot flow','Cold flow')

for k = 1:length(t)
    
    set(h3,'XData',x,'Ydata',TH);
    set(h4,'XData',x,'Ydata',TC);
    drawnow;
    
    f = d1.*(TH-TC);
    TH = lax_wendroff(TH, f, c1, dt, dx);
    f = d2.*(TH-TC);
    TC = lax_wendroff(TC, f, c2, dt, dx);
end
