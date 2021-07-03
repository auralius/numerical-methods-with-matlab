function U = dirichlet_poisson_solver(p, ... % left
                                      q, ... % bottom
                                      r, ... % right
                                      s, ... % top
                                      f, ... % forcing component
                                      a, ... % dimension along x-axis
                                      b, ... % dimension along y-axis
                                      h)     % dx=dy=h

% dx = dy = h
N = a/h; % number of columns
M = b/h; % number of rows

% Create matrix U
U = zeros(M+1,N+1);

% Apply boundary conditions
for j = 1 : M+1 
  U(j,1) =  q(h*(j-1));
  U(j,N+1) = s(h*(j-1));
end

for k = 1 : N+1
  U(1,k) = p(h*(k-1));
  U(M+1,k) = r(h*(k-1));
end

fprintf('Matrix U with the boundary applied:\nU =\n');
disp(U);

% For Poisson system, prepare matrix F
F = zeros((M-1)*(N-1),1);

n = 1;
for j= 1 : M-1 
  for k = 1 : N-1 
    F(n,1) = f((j)*h,(k)*h);
    n = n+1;
  end 
end

% AU=c, solve for U
A = create_A(M, N);
c = create_c(U, F, h);
fprintf('AU = c, where:\n');
fprintf('A =\n')
disp(A);
fprintf('c =\n')
disp(c);

% Find solutions
fprintf('Solve for U = LinearSolve(A,c)\n');
sol = A\c;

% Put the solutions back to matrix U, pay atention that the row goes first 
% followed by the column
n = 1;
for k = 2 : N 
  for j = 2 : M 
    U(j,k) = sol(n);
    n = n+1;
  end 
end   

fprintf('U =\n');
disp(U);
end