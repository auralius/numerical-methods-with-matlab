function next_u_array = lax_wendroff(u_array, f_array, c, dt, dx)

N = length(u_array);
next_u_array = u_array;


% the ordinary way
for i = 2:N-1
    next_u_array(i) = u_array(i)-0.5*c*dt/dx*(u_array(i+1)-u_array(i-1)) + 0.5*(c*dt/dx)^2 * (u_array(i+1)-2*u_array(i)+u_array(i-1)) + f_array(i)*dt;
end


                  
% fill up the two ends by using upwind or downwind method                  
if c > 0
    next_u_array(N) = u_array(N) - c*dt/dx* ...
                    (u_array(N)- u_array(N-1)) + f_array(N)*dt;  
    
elseif c < 0
    next_u_array(1) = u_array(1) - c*dt/dx* ...
                      (u_array(2) - u_array(1)) + f_array(1)*dt;   
    

end