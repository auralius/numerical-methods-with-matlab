% m = number of rows = Ny+2
% n = number of columns = Nx+2
function A = create_A(m, n)
 
  N = (m-1)*(n-1);
  A = zeros(N,N);

  for j = 1 : N 
    for k = 1 : N 
      if j==k   
        A(j,k) = -4;
      elseif abs(j-k) == 1 
        A(j,k) = 1;
      elseif abs(j-k) == m-1  
        A(j,k) = 1;
      end 
    end 
  end 

  for j = 1 : N-1 
    for k = 1 : N-1 
      if j == k && rem(j,m-1) == 0 
        A(j+1,k) = 0;
      end
      if j == k && rem(k,m-1) == 0 
        A(j,k+1) = 0;
      end
    end
  end
  
end

