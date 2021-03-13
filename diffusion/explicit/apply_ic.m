function u_array = apply_ic(u_array, f, Delta_x)

% Apply the initial condition U(x,0)=f(x)
j = 1:length(u_array);
u_array(j) = f((j-1)*Delta_x);

end