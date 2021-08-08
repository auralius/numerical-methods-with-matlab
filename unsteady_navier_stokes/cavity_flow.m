%%
clear
clc
close all

%%
lx = 1;      % Domain width
ly = 1;      % Domain height

dx = 1/200;  % Horizontal spatial increment
dy = 1/200;  % Vertical spatial increment

dt = 0.001;  % Temporal increment

rho = 1.0;   % Fluid's density
re = 50;     % Reynold's number
nu = 0.001;  % Dynamic viscosity

tsim = 10;   % How long?

%%
[t, X, Y, U, V,CE] = cavity_flow_solver(lx,...
    ly, ...
    dx, ...
    dy, ...
    dt, ...
    rho, ...
    nu, ...
    re, ...
    tsim);


%% Preparation for plotting U
hfig1 = figure;
hold on
contourf(X,Y,U(:,:,1));
colormap(jet);
colorbar;
axis square;
hutext = text(0.5,-0.1, 'Time=');
hutext.FontWeight = 'bold';
title('Horizontal Fluid Velocity (u)')

for k=1:length(t)
    if mod(k-1,100) == 0
        contourf(X,Y,U(:,:,k));
        hutext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig1, k, 'u.gif');
    end
end

%% Preparation for plotting V
hfig2 = figure;
hold on
contourf(X,Y,V(:,:,1));
colormap(jet);
colorbar;
axis square;
hutext = text(0.5,-0.1, 'Time=');
hutext.FontWeight = 'bold';
title('Vertical Fluid Velocity (v)')

for k=1:length(t)
    if mod(k-1,100) == 0
        contourf(X,Y,V(:,:,k));
        hutext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig2, k, 'v.gif');
    end
end

%%
hfig3 = figure;
hold on
contourf(X,Y,sqrt(U(:,:,1).^2+V(:,:,1).^2));
colormap(jet);
colorbar;
axis square;
hutext = text(0.5,-0.1, 'Time=');
hutext.FontWeight = 'bold';
title('Overall Velocity Magnitude (norm(U+V))')

for k=1:length(t)
    if mod(k-1,100) == 0
        contourf(X,Y,sqrt(U(:,:,k).^2+V(:,:,k).^2))
        hutext.String = ['Time=', num2str((k-1)*dt),'s'] ;
        drawnow
        write2gif(hfig3, k, 'norm_uv.gif');
    end
end
