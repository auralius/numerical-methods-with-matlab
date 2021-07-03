% Types of boudaries:
%   'fixed' and 'fixed' 
%   'pinned' and 'pined'
%   'fixed' and 'pinned'
%   'pinned' and 'fixed'
%   'fixed' and 'free'
%   'pined' and 'free'

function beam = create_beam(E, I, length, N, f, lb, rb)

beam.E = E;
beam.I = I;
beam.length = length;
beam.N = N;
beam.dx = length / N;
beam.f = f;
beam.lb = lb;
beam.rb = rb;

beam.x = linspace(0, length, N);
beam.w = zeros(N,1);             % Beam deflection 
beam.moment = zeros(N,1);      % Internal bending moment
beam.shear_force = zeros(N,1); % Internal shear force

end