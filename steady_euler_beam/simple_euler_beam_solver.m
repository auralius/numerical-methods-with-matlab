function beam = simple_euler_beam_solver(beam)

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
    
    beam.w(2:end-1) = (A\beam.f(2:end-1)) .* beam.dx^4 ./ (beam.E * beam.I);

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
    
    beam.w(2:end-1) = (A\beam.f(2:end-1)) .* beam.dx^4 ./ (beam.E * beam.I);

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
    
    beam.w(2:end-1) = (A\beam.f(2:end-1)) .* beam.dx^4 ./ (beam.E * beam.I);
    
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
    
    beam.w(2:end-1) = (A\beam.f(2:end-1)) .* beam.dx^4 ./ (beam.E * beam.I);
    
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
    
    beam.w(2:end) = (A\beam.f(2:end)) .* beam.dx^4 ./ (beam.E * beam.I);
    
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
    
    beam.w(2:end) = (A\beam.f(2:end)) .* beam.dx^4 ./ (beam.E * beam.I);

else
    disp('Error: boundary not known.');
    return;
end

    beam = compute_moment_and_shear_force(beam);
    
end