function [u_next,v_next,p_next] = ns_solver_2d(u, ...
                                               v, ...
                                               p, ...
                                               nx, ...
                                               ny, ...
                                               dx, ...
                                               dy, ...
                                               dt, ...
                                               rho, ...
                                               nu, ...
                                               pressure_bc_types, ...
                                               pressure_bc_values, ...
                                               u_bc_types, ...
                                               u_bc_values, ...
                                               v_bc_types, ...
                                               v_bc_values)



for k = 1 : 10
    for i = 2:nx-1
        for j = 2:ny-1   
            p(j,i) = -rho*dx^2*dy^2/(2*(dx^2+dy^2)) * (...
                         1/dt*( (u(j,i+1)-u(j,i-1))/(2*dx) + ...
                                (v(j+1,i)-v(j-1,i))/(2*dy) ) - ...
                         ((u(j,i+1)-u(j,i-1))/(2*dx))^2 - ...
                         2*(u(j+1,i)-u(j-1,i))/(2*dy) * ...
                             (v(j,i+1)-v(j,i-1))/(2*dx) - ...
                         ((v(j+1,i)-v(j-1,i))/(2*dy))^2) + ...
                     1/(2*(dx^2+dy^2)) * (...
                         dy^2*(p(j,i-1)+p(j,i+1)) + ...
                         dx^2*(p(j+1,i)+p(j-1,i)));
        end
    end
    
    % apply BC for pressure    
    p = apply_bc(p, dx, dy, pressure_bc_types, pressure_bc_values);
    
end
p_next = p;

u_next = zeros(nx,ny);
v_next = zeros(nx,ny);

for i = 2:nx-1
    for j = 2:ny-1       
        u_next(j,i) = -dt/(2*rho*dx)*(p(j,i+1)-p(j,i-1)) + ...
                      dt*nu*( (u(j,i+1)-2*u(j,i)+u(j,i-1))/dx^2 + ...
                              (u(j+1,i)-2*u(j,i)+u(j-1,i))/dy^2 ) - ...
                      dt/dx*u(j,i)*(u(j,i)-u(j,i-1)) - ...        
                      dt/dy*v(j,i)*(u(j,i)-u(j-1,i)) + ...
                      u(j,i);
                  
        v_next(j,i) = -dt/(2*rho*dy)*(p(j+1,i)-p(j-1,i)) + ...
                      dt*nu*( (v(j,i+1)-2*v(j,i)+v(j,i-1))/dx^2 + ...
                              (v(j+1,i)-2*v(j,i)+v(j-1,i))/dy^2 ) - ...
                      dt/dx*u(j,i)*(v(j,i)-v(j,i-1)) - ...        
                      dt/dy*v(j,i)*(v(j,i)-v(j-1,i)) + ...
                      v(j,i);
    end
end

% Apply BC for u and v
u_next = apply_bc(u_next, dx, dy, u_bc_types, u_bc_values);
v_next = apply_bc(v_next, dx, dy, v_bc_types, v_bc_values);
end