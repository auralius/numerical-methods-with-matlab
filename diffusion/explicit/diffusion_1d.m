% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L with Delta_x increments
% Divide 0<=t<=tF with Delta_t5 increments

function u_array = diffusion_1d(u_array, ...
                                g_array, ...
                                alpha, ...
                                Delta_x, ...
                                Delta_t)

r = alpha^2*Delta_t/Delta_x^2;

j = 2:length(u_array)-1;
u_array(j) = r*u_array(j-1) + (1-2*r) * u_array(j) + r*u_array(j+1) + g_array(j)*Delta_t;
 
end 