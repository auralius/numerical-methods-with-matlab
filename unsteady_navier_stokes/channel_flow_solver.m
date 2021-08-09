function [t,X,Y,U,V, CE] = channel_flow_solver(lx, ...
    ly, ...
    dx, ...
    dy, ...
    dt, ...
    rho, ...
    nu, ...
    ip, ...
    op, ...
    tsim)

% start from zero, add phantom nodes
nx = ceil(lx/dx)+1+2;
ny = ceil(ly/dy)+1+2;

% The order of the boundaries: left, right, top, bottom
u_bc_types =  ["dirichlet", "dirichlet", "dirichlet", "dirichlet"];
u_bc_values = [0, 0, 0, 0];

v_bc_types =  ["dirichlet", "dirichlet", "dirichlet", "dirichlet"];
v_bc_values = [0, 0, 0, 0];

p_bc_types = ["dirichlet", "dirichlet", "neumann", "neumann"];
p_bc_values = [ip, op, 0, 0];

% Phantom nodes in all sides, even though the boundary is a Dirichlet type
u = zeros(ny,nx);
v = zeros(ny,nx);
p = zeros(ny,nx);

u_hat = zeros(ny,nx);
v_hat = zeros(ny,nx);
b = zeros(ny,nx);

residual = zeros(ny,nx);

p = apply_bc(p, dx, dy, p_bc_types, p_bc_values);
u = apply_bc(u, dx, dy, u_bc_types, u_bc_values);
v = apply_bc(v, dx, dy, u_bc_types, v_bc_values);

n_it = ceil((tsim+1)/dt);

U = zeros(ny-2,nx-2,n_it);
V = zeros(ny-2,nx-2,n_it);
t = zeros(n_it, 1);
CE = zeros(n_it, 1);

for k = 1 : n_it
    
    error = 1;
    
    for i = 2:nx-1
        for j = 2:ny-1
            b(j,i) = rho/dt*((u(j,i+1)-u(j,i-1))/(2*dx) + (v(j+1,i)-v(j-1,i))/(2*dy));
        end
    end
    
    % Solve the pressure equation
    % Gauss-Siedel loop
    while error > 1e-5
        p_old = p;
        
        for i = 3:nx-2       % Dirichlet must no modify the boundary
            for j = 2:ny-1   
                p(j,i) = ...
                    (dy^2*(p(j,i-1)+p(j,i+1)) + ...
                    dx^2*(p(j+1,i)+p(j-1,i)) - ...
                    dx^2*dy^2*b(j,i)) / ...
                    (2*(dx^2+dy^2));
            end
        end
        
        % apply BC for pressure
        p = apply_bc(p, dx, dy, p_bc_types, p_bc_values);
        
        E = (p_old - p).^2;
        error = sqrt(sum(E(:))/numel(E));
    end
    
    % Update u
    for i = 3:nx-2      % Dirichlet must no modify the boundary
        for j = 3:ny-2  % Dirichlet must no modify the boundary
            u_hat(j,i) = dt*(...
                -(p(j,i+1)-p(j,i-1))/(2*rho*dx) + ...
                nu*( (u(j,i+1)-2*u(j,i)+u(j,i-1))/dx^2 + ...
                (u(j+1,i)-2*u(j,i)+u(j-1,i))/dy^2 ) - ...
                u(j,i)*(u(j,i+1)-u(j,i-1))/(2*dx) - ...
                v(j,i)*(u(j+1,i)-u(j-1,i))/(2*dy)) + ...
                u(j,i);
        end
    end
    u = apply_bc(u_hat, dx, dy, u_bc_types, u_bc_values);
    
    % Update v
    for i = 3:nx-2      % Dirichlet must no modify the bouundary
        for j = 3:ny-2  % Dirichlet must no modify the bouundary
            v_hat(j,i) = dt*(...
                -(p(j+1,i)-p(j-1,i))/(2*rho*dy) + ...
                nu*( (v(j,i+1)-2*v(j,i)+v(j,i-1))/dx^2 + ...
                (v(j+1,i)-2*v(j,i)+v(j-1,i))/dy^2 ) - ...
                u(j,i)*(v(j,i+1)-v(j,i-1))/(2*dx) - ...
                v(j,i)*(v(j+1,i)-v(j-1,i))/(2*dy)) + ...
                v(j,i);
        end
    end
    v = apply_bc(v_hat, dx, dy, v_bc_types, v_bc_values);
    
    % Continuity residual
    for i = 3:nx-2      % Do not include the boundary
        for j = 3:ny-2
            residual(j,i) = (u(j,i+1)-u(j,i-1))/(2*dx) + (v(j+1,i)-v(j-1,i))/(2*dy);
        end
    end
    
    R = residual(3:ny-2, 3:nx-2);
    
    CE(k) = sum(abs(R(:)))/numel(R);
    U(:,:,k) = flipud(u(2:end-1,2:end-1));
    V(:,:,k) = -flipud(v(2:end-1,2:end-1));
    t(k) = (k-1)*dt;
    X = 0:dx:lx;
    Y = 0:dy:ly;
end

end