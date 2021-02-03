function next_u_array = lax(u_array, f_array, c, dt, dx)

N = length(u_array);
next_u_array = u_array;

alpha = c*dt/dx;
    
% the ordinary way
%for i = 2:N-1
%    next_u_array(i) = 0.5*(u_array(i+1)+u_array(i-1)) - ...
%                       0.5*alpha*(u_array(i+1)-u_array(i-1)) + ...
%                       f_array(i)*dt;
%end

% let's do it the MATLAB way!
next_u_array(2:N-1) = 0.5.*(u_array(3:N)+(u_array(1:N-2))) - ...
                      (0.5*alpha).* (u_array(3:N)- u_array(1:N-2)) + ...
                      f_array(2:N-1).*dt;  

                  
% fill up the two ends by using upwind or downwind method                  
if c > 0
    next_u_array(N) = u_array(N) - alpha* ...
                    (u_array(N)- u_array(N-1)) + f_array(N).*dt;  
    
elseif c < 0
    next_u_array(1) = u_array(1) - alpha* ...
                      (u_array(2) - u_array(1)) + f_array(1).*dt;   
    

end