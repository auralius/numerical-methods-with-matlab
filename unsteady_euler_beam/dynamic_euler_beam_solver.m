function beam = dynamic_euler_beam_solver(beam, sim_time)

global Q;

if strcmp(beam.lb, 'fixed') && strcmp(beam.rb, 'fixed') 
    A = zeros(beam.N-2, beam.N-2); % the first node and last node are excluded
    
    A(1,1:3) = [7 -4 1];
    A(2,1:4) = [-4 6 -4 1];
    A(3,1:5) = [1 -4 6 -4 1];
    
    for k = 1 : beam.N-7
        A(k+3,:) = circshift(A(k+2,:),1);
    end
    A(end-1, end-3:end) = [1 -4 6 -4];
    A(end, end-2:end) = [1 -4 7];
    
    
elseif strcmp(beam.lb, 'pinned') && strcmp(beam.rb, 'pinned') 
    A = zeros(beam.N-2, beam.N-2); % the first node and last node are excluded
    
    A(1,1:3) = [5 -4 1];
    A(2,1:4) = [-4 6 -4 1];
    A(3,1:5) = [1 -4 6 -4 1];
    
    for k = 1 : beam.N-7
        A(k+3,:) = circshift(A(k+2,:),1);
    end
    A(end-1, end-3:end) = [1 -4 6 -4];
    A(end, end-2:end) = [1 -4 5];
    
elseif strcmp(beam.lb, 'fixed') && strcmp(beam.rb, 'pinned') 
    A = zeros(beam.N-2, beam.N-2); % the first node and last node are excluded
    
    A(1,1:3) = [7 -4 1];
    A(2,1:4) = [-4 6 -4 1];
    A(3,1:5) = [1 -4 6 -4 1];
    
    for k = 1 : beam.N-7
        A(k+3,:) = circshift(A(k+2,:),1);
    end
    A(end-1, end-3:end) = [1 -4 6 -4];
    A(end, end-2:end) = [1 -4 5];
       
elseif strcmp(beam.lb, 'pinned') && strcmp(beam.rb, 'fixed') 
    A = zeros(beam.N-2, beam.N-2); % the first node and last node are excluded
    
    A(1,1:3) = [5 -4 1];
    A(2,1:4) = [-4 6 -4 1];
    A(3,1:5) = [1 -4 6 -4 1];
    
    for k = 1 : beam.N-7
        A(k+3,:) = circshift(A(k+2,:),1);
    end
    A(end-1, end-3:end) = [1 -4 6 -4];
    A(end, end-2:end) = [1 -4 7];
        
elseif strcmp(beam.lb, 'fixed') && strcmp(beam.rb, 'free') 
    A = zeros(beam.N-1, beam.N-1); % only the first node is excluded
    
    A(1,1:3) = [7 -4 1];
    A(2,1:4) = [-4 6 -4 1];
    A(3,1:5) = [1 -4 6 -4 1];
    
    for k = 1 : beam.N-6
        A(k+3,:) = circshift(A(k+2,:),1);
    end
    A(end-1, end-3:end) = [1 -4 5 -2];
    A(end, end-2:end) = [2 -4 2];
    
    start_index = 2;
    end_index = beam.N;
        
elseif strcmp(beam.lb, 'pinned') && strcmp(beam.rb, 'free') 
    A = zeros(beam.N-1, beam.N-1); % only the first node is excluded
    
    A(1,1:3) = [5 -4 1];
    A(2,1:4) = [-4 6 -4 1];
    A(3,1:5) = [1 -4 6 -4 1];
    
    for k = 1 : beam.N-6
        A(k+3,:) = circshift(A(k+2,:),1);
    end
    A(end-1, end-3:end) = [1 -4 5 -2];
    A(end, end-2:end) = [2 -4 2];
    
else
    disp('Error: boundary not known.');
    return;
end

n = end_index - start_index + 1;

I = eye(size(A));
O = zeros(size(A));

Q = [O I; -beam.E*beam.I/beam.dx^4.*A O];
X0 = zeros(n*2,1);
[t,X]=ode15s(@beam_ode, [0 sim_time], X0, [], @beam.f, start_index, end_index);

beam.w = zeros(length(t), beam.N);
beam.w(:,start_index : end_index) = X(:,1:n);
beam.t = t;

% ------------------------------------------------------------------------
    function XDOT = beam_ode(t, X, f, start_index, end_index)
        n = end_index - start_index + 1;
        F = [zeros(n,1); f(start_index:end_index, t)];       

        XDOT = Q*X + F;
    end
% ------------------------------------------------------------------------

end