% alpha^2 * u_xx = u_tt
% Divide 0<=x<=L into Nx segments
% Divide 0<=t<=tF into Nt segments
% p(t) is the left boundary conditoin
% q(t) is the right boundary condition
% f(x) is the initial condition

function U = diffusion_1d(alpha, p, q, f, L, Nx, Nt, tF)

Delta_x = L/Nx;
Delta_t = tF/Nt;

% Prepare the matrix u
U = zeros(Nx+1,Nt+1);

% Apply the initial condition U(x,0)=f(x)
j = 1:Nx+1;
U(j,1) = f((j-1)*Delta_x);

% Keep the boundary condition
k = 1:Nt;  
U(1,k) = p((k-1)*Delta_t);
U(Nx+1,k) = q((k-1)*Delta_t);

r = alpha^2*Delta_t/Delta_x^2;

for k = 1:Nt      % time-wise 
    j = 2 : Nx;   % length-wise
    U(j,k+1) = r*U(j-1,k) + (1-2*r) * U(j,k) + r*U(j+1,k);
end
  
U = U(:,1:Nt); % the last column is untouched, remove it

end