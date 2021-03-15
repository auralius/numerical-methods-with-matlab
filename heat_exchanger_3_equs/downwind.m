function next_u_array = downwind(u_array, f_array, c, dt, dx)

N = length(u_array);
next_u_array = u_array;

% the ordinary way
%for i = 1:N-1
%    next_u_array(i) = u_array(i)-c*dt/dx*(u_array(i+1)-u_array(i))+f_array(i)*dt;
%end

% let's do it the MATLAB way!
next_u_array(1:N-1) = u_array(1:N-1) - (c*dt/dx).* ...
                      (u_array(2:N) - u_array(1:N-1)) + f_array(1:N-1).*dt;   
    
end