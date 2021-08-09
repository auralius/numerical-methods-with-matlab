%%
clear
clc
close all

%%
lx = 3;      % Domain width
ly = 0.1;    % Domain height

dx = 1/300;  % Horizontal spatial increment
dy = 1/100;  % Vertical spatial increment

dt = 0.001;  % Temporal increment

rho = 1000;  % Fluid's density
nu = 0.001;  % Dynamic viscosity

tsim = 10;   % How long?

ip = 5;      % Inlet pressure 
op = 2;      % Outlet pressure 


%%
[t, X, Y, U, V,CE] = channel_flow_solver(lx,...
    ly, ...
    dx, ...
    dy, ...
    dt, ...
    rho, ...
    nu, ...  
    ip, ...
    op, ...
    tsim);


%% Preparation for plotting U
hfig1 = figure;
hold on
contourf(X,Y,U(:,:,1));
colormap(jet);
colorbar;
caxis([0 max(U(:))])
hutext = text(1,-0.01, 'Time=');
hutext.FontWeight = 'bold';
title('Horizontal Fluid Velocity (u)')

for k=1:length(t)
    if mod(k-1,100) == 0
        contourf(X,Y,U(:,:,k));
        hutext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig1, k, 'channel_flow_u.gif');
    end
end

%% Preparation for plotting V
hfig2 = figure;
hold on
contourf(X,Y,V(:,:,1));
colormap(jet);
colorbar;
caxis([0 max(V(:))])
hutext = text(1,-0.01, 'Time=');
hutext.FontWeight = 'bold';
title('Vertical Fluid Velocity (v)')

for k=1:length(t)
    if mod(k-1,100) == 0
        contourf(X,Y,V(:,:,k));
        hutext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig2, k, 'channel_flow_v.gif');
    end
end
