function next_u_array = lax_solver(u_array, f_array, c, dt, dx)

N = length(u_array);
next_u_array = u_array;

alpha = c*dt/dx;
    
% the ordinary way
for i = 2:N-1
    next_u_array(i) = 0.5*(u_array(i+1)+u_array(i-1)) - ...
                       0.5*alpha*(u_array(i+1)-u_array(i-1)) + ...
                       f_array(i)*dt;
end

    

end

function T_new = advection_diffusion_lax_solver(T, ...      % Temperature matrix
                                        u, ...      % x-velocity matrix
                                        v, ...      % y-velocity matrix  
                                        dt, ...     % time step
                                        dx, ...     % delta x
                                        dy,...      % delta y
                                        alpha, ...  % thermal diffusivity
                                        f)          % external forcing term
r = size(T,1);
c = size(T,2);
T_new = zeros(r,c);

for i = 2:r-1
    for j = 2:c-1
       if (u(i,j)>=0 && v(i,j)>=0)   % upwind-upwind
           T_new(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i,j)-T(i-1,j)) + ... 
                    v(i,j)/dy * (T(i,j)-T(i,j-1)) ) + ...
                    T(i,j) + f(i,j)*dt;
                
       elseif (u(i,j)<0 && v(i,j)<0)   % downwind-downwind
            T_new(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i+1,j)-T(i,j)) + ... 
                    v(i,j)/dy * (T(i,j+1)-T(i,j)) ) + ...
                    T(i,j) + f(i,j)*dt;
                
       elseif (u(i,j)>=0 && v(i,j)<0)   % upwind-downwind
            T_new(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i,j)-T(i-1,j)) + ... 
                    v(i,j)/dy * (T(i,j+1)-T(i,j)) ) + ...
                    T(i,j) + f(i,j)*dt;
                
        elseif (u(i,j)<0 && v(i,j)>=0)   % downwind-upwind
            T_new(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i+1,j)-T(i,j)) + ... 
                    v(i,j)/dy * (T(i,j)-T(i,j-1)) ) + ...
                    T(i,j) + f(i,j)*dt;
       end
    end
end
end