function next_u_array = lax_wendroff_solver(u_array, f_array, c, dt, dx)

N = length(u_array);
next_u_array = u_array;

r = c*dt/dx;

%for i = 2:N-1
%    next_u_array(i) = u_array(i)-0.5*r*(u_array(i+1)-u_array(i-1)) ...
%                      + 0.5*r^2 * (u_array(i+1)-2*u_array(i)+u_array(i-1)) ... 
%                      + f_array(i)*dt;
%end

% let's do it the MATLAB's way
next_u_array(2:N-1) = u_array(2:N-1)-0.5*r*(u_array(3:N)-u_array(1:N-2)) ...
                      + 0.5*r^2 * (u_array(3:N)-2*u_array(2:N-1)+u_array(1:N-2)) ... 
                      + f_array(2:N-1)*dt;

% fill up the two ends by using upwind or downwind method                  
if c > 0
    next_u_array(N) = u_array(N) - r* ...
                    (u_array(N)- u_array(N-1)) + f_array(N)*dt;  
    
elseif c < 0
    next_u_array(1) = u_array(1) - r* ...
                      (u_array(2) - u_array(1)) + f_array(1)*dt;   
    
end
