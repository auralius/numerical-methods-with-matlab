function T = advection_diffusion(T, ...      % Temperature matrix
                                 u, ...      % x-velocity matrix
                                 v, ...      % y-velocity matrix  
                                 dt, ...     % time step
                                 dx, ...     % delta x
                                 dy,...      % delta y
                                 alpha, ...  % thermal diffusivity
                                 f)          % external forcing term
r = size(T,1);
c = size(T,2);

for i = 2:r-1
    for j = 2:c-1
       if (u(i,j)>=0 && v(i,j)>=0)   % upwind-upwind
           T(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i,j)-T(i-1,j)) + ... 
                    v(i,j)/dy * (T(i,j)-T(i,j-1)) ) + ...
                    T(i,j) + f(i,j)*dt;
                
       elseif (u(i,j)<0 && v(i,j)<0)   % downwind-downwind
            T(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i+1,j)-T(i,j)) + ... 
                    v(i,j)/dy * (T(i,j+1)-T(i,j)) ) + ...
                    T(i,j) + f(i,j)*dt;
                
       elseif (u(i,j)>=0 && v(i,j)<0)   % upwind-downwind
            T(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i,j)-T(i-1,j)) + ... 
                    v(i,j)/dy * (T(i,j+1)-T(i,j)) ) + ...
                    T(i,j) + f(i,j)*dt;
                
        elseif (u(i,j)<0 && v(i,j)>=0)   % downwind-upwind
            T(i,j) = alpha*dt * ( (T(i+1,j)-2*T(i,j)+T(i-1,j))/dx^2 + ...
                    (T(i,j+1)-2*T(i,j)+T(i,j-1))/dy^2 ) - ...
                    dt * (u(i,j)/dx * (T(i+1,j)-T(i,j)) + ... 
                    v(i,j)/dy * (T(i,j)-T(i,j-1)) ) + ...
                    T(i,j) + f(i,j)*dt;
       end
    end
end
end