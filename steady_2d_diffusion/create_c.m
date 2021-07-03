function c = create_c(U, F, h)

[m, n] = size(U);
M = m-2; % first row and last row are the boundaries
N = n-2; % first column and the last column are the boundaries

c = zeros(M*N,1);
c = (h^2) * F;

% Hang on on tight, here we go!
% MATLAB index starts from 1 not 0!
for j=1 : M
    for k = 1 : N
        
        if (j==1) % Top row 
            c(j+(k-1)*M,1) = c(j+(k-1)*M,1)-U(1,k+1);
        end
        if (k==1) % Left-most column
            c(j+(k-1)*M,1)=c(j+(k-1)*M,1)-U(j+1,1);
        end
        if (j==M) % Bottom row
            c(j+(k-1)*M,1)=c(j+(k-1)*M,1)-U(end,k+1);
        end
        if (k==N) % Right-most column
            c(j+(k-1)*M,1)=c(j+(k-1)*M,1)-U(k+1,end);
        end
        
    end
end


end