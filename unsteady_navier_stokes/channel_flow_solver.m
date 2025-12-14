function [t,X,Y,U,V,CE,p] = channel_flow_solver( ...
    lx, ly, dx, dy, dt, rho, nu, ip, op, tsim)
%CHANNEL_FLOW_SOLVER_PROJECTION
% Educational 2D incompressible Navier–Stokes solver (projection method)
% on a collocated grid with exactly ONE ghost layer on each side.
%
% Grid indexing:
%   i = 2..nx-1, j = 2..ny-1  -> physical (interior) cells
%   i = 1 and i = nx          -> ghost cells (left/right)
%   j = 1 and j = ny          -> ghost cells (top/bottom)
%
% Each time step:
%   1) compute intermediate velocities u*, v* (NO pressure)
%   2) build Poisson RHS b = (rho/dt) div(u*)
%   3) solve Lap(p) = b (Gauss–Seidel)
%   4) correct velocities u^{n+1} = u* - (dt/rho) grad(p)
%
% NOTE:
% - Centered convection + explicit Euler can be unstable at higher Re.
% - Pressure-driven "channel" behavior depends strongly on inlet/outlet BCs.

% --- Grid (physical points: 0:dx:lx, 0:dy:ly; plus 1 ghost each side) ---
nx_phys = ceil(lx/dx) + 1;
ny_phys = ceil(ly/dy) + 1;

nx = nx_phys + 2;   % +2 = one ghost on each side
ny = ny_phys + 2;

% Coordinates of physical domain (for plotting / output)
X = 0:dx:lx;
Y = 0:dy:ly;

% --- Boundary conditions: order = left, right, top, bottom ---
% (These act on the ghost cells i=1,i=nx and j=1,j=ny)
u_bc_types  = ["neumann","neumann","dirichlet","dirichlet"];
u_bc_values = [0, 0, 0, 0];

v_bc_types  = ["neumann","neumann","dirichlet","dirichlet"];
v_bc_values = [0, 0, 0, 0];

p_bc_types  = ["dirichlet","dirichlet","neumann","neumann"];
p_bc_values = [ip, op, 0, 0];

% --- Fields (including ghost layer) ---
u     = zeros(ny,nx);
v     = zeros(ny,nx);
p     = zeros(ny,nx);
u_hat = zeros(ny,nx);
v_hat = zeros(ny,nx);
b     = zeros(ny,nx);
residual = zeros(ny,nx);

% Apply initial BCs
p = apply_bc_1ghost(p, dx, dy, p_bc_types, p_bc_values);
u = apply_bc_1ghost(u, dx, dy, u_bc_types, u_bc_values);
v = apply_bc_1ghost(v, dx, dy, v_bc_types, v_bc_values);

% --- Time storage ---
n_it = ceil((tsim+1)/dt);
U  = zeros(ny-2, nx-2, n_it);  % store physical region only
V  = zeros(ny-2, nx-2, n_it);
t  = zeros(n_it, 1);
CE = zeros(n_it, 1);

% --- Poisson solver parameters ---
poisson_tol = 1e-5;
poisson_max_iter = 5000;

for k = 1:n_it

    % =========================================================
    % Step 1: intermediate velocities u*, v* (NO pressure)
    % =========================================================
    for i = 2:nx-1
        for j = 2:ny-1
            % convection (centered)
            duudx = u(j,i) * (u(j,i+1)-u(j,i-1)) / (2*dx);
            dvudy = v(j,i) * (u(j+1,i)-u(j-1,i)) / (2*dy);

            duvdx = u(j,i) * (v(j,i+1)-v(j,i-1)) / (2*dx);
            dvvdy = v(j,i) * (v(j+1,i)-v(j-1,i)) / (2*dy);

            % diffusion (Laplacian)
            lapu = (u(j,i+1)-2*u(j,i)+u(j,i-1))/dx^2 + ...
                   (u(j+1,i)-2*u(j,i)+u(j-1,i))/dy^2;

            lapv = (v(j,i+1)-2*v(j,i)+v(j,i-1))/dx^2 + ...
                   (v(j+1,i)-2*v(j,i)+v(j-1,i))/dy^2;

            u_hat(j,i) = u(j,i) + dt*( -duudx - dvudy + nu*lapu );
            v_hat(j,i) = v(j,i) + dt*( -duvdx - dvvdy + nu*lapv );
        end
    end

    u_hat = apply_bc_1ghost(u_hat, dx, dy, u_bc_types, u_bc_values);
    v_hat = apply_bc_1ghost(v_hat, dx, dy, v_bc_types, v_bc_values);

    % =========================================================
    % Step 2: build Poisson RHS b = (rho/dt) div(u*)
    % =========================================================
    for i = 2:nx-1
        for j = 2:ny-1
            b(j,i) = rho/dt * ( ...
                (u_hat(j,i+1)-u_hat(j,i-1))/(2*dx) + ...
                (v_hat(j+1,i)-v_hat(j-1,i))/(2*dy) );
        end
    end

    % =========================================================
    % Step 3: solve Poisson: Lap(p) = b (Gauss–Seidel)
    % =========================================================
    err = inf;
    itp = 0;

    while err > poisson_tol && itp < poisson_max_iter
        itp = itp + 1;
        p_old = p;

        for i = 2:nx-1
            for j = 2:ny-1
                p(j,i) = ( ...
                    dy^2*(p(j,i-1)+p(j,i+1)) + ...
                    dx^2*(p(j-1,i)+p(j+1,i)) - ...
                    dx^2*dy^2*b(j,i) ) / (2*(dx^2+dy^2));
            end
        end

        p = apply_bc_1ghost(p, dx, dy, p_bc_types, p_bc_values);

        E = (p_old - p).^2;
        err = sqrt(sum(E(:))/numel(E));
    end

    % =========================================================
    % Step 4: projection (pressure correction)
    % =========================================================
    for i = 2:nx-1
        for j = 2:ny-1
            u(j,i) = u_hat(j,i) - dt/(2*rho*dx) * (p(j,i+1) - p(j,i-1));
            v(j,i) = v_hat(j,i) - dt/(2*rho*dy) * (p(j+1,i) - p(j-1,i));
        end
    end

    u = apply_bc_1ghost(u, dx, dy, u_bc_types, u_bc_values);
    v = apply_bc_1ghost(v, dx, dy, v_bc_types, v_bc_values);

    % =========================================================
    % Diagnostics: continuity residual (interior only)
    % =========================================================
    for i = 2:nx-1
        for j = 2:ny-1
            residual(j,i) = (u(j,i+1)-u(j,i-1))/(2*dx) + ...
                            (v(j+1,i)-v(j-1,i))/(2*dy);
        end
    end

    R = residual(2:ny-1, 2:nx-1);
    CE(k) = sum(abs(R(:))) / numel(R);

    % Store fields (strip ghost layer)
    U(:,:,k) = flipud(u(2:end-1, 2:end-1));
    V(:,:,k) = -flipud(v(2:end-1, 2:end-1));
    t(k) = (k-1)*dt;
end

end


% ======================================================================
% One-ghost-layer boundary conditions helper
% Order of boundaries: left, right, top, bottom
% Dirichlet: set ghost cell value
% Neumann:   enforce derivative using first interior cell
% ======================================================================
function U = apply_bc_1ghost(U, dx, dy, types, values)

nr = size(U,1);
nc = size(U,2);

% left (i = 1)
if lower(types(1)) == "dirichlet"
    U(:,1) = values(1);
elseif lower(types(1)) == "neumann"
    U(:,1) = U(:,2) - dx * values(1);
end

% right (i = nc)
if lower(types(2)) == "dirichlet"
    U(:,nc) = values(2);
elseif lower(types(2)) == "neumann"
    U(:,nc) = U(:,nc-1) + dx * values(2);
end

% top (j = 1)
if lower(types(3)) == "dirichlet"
    U(1,:) = values(3);
elseif lower(types(3)) == "neumann"
    U(1,:) = U(2,:) - dy * values(3);
end

% bottom (j = nr)
if lower(types(4)) == "dirichlet"
    U(nr,:) = values(4);
elseif lower(types(4)) == "neumann"
    U(nr,:) = U(nr-1,:) + dy * values(4);
end

end
