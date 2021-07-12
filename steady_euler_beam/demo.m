clear 
close all
clc

%%
E = 210e9;      % Young's modulus, in Pascal
L = 2;          % Length, in m
I = 4e-6;       % Second area of momment inertia, in m^4 

N = 1000;       % Number of segments

f = zeros(N,1); % The load (N/m or N)
f(ceil(end/2)) = -40e3; % Concetrated load in the mid-center of the beam

%%
% Ex.1
beam = create_beam(E, I, L, N, f, 'fixed', 'free');
beam = simple_euler_beam_solver(beam);
fig = beam_visualization(beam, 'Fixed-Free');
saveas(fig,'fixed-free.png');

%%
% Ex. 2
beam = create_beam(E, I, L, N, f, 'fixed', 'fixed');
beam = simple_euler_beam_solver(beam);
fig = beam_visualization(beam, 'Fixed-Fixed');
saveas(fig,'fixed-fixed.png');

%%
% Ex. 3
beam = create_beam(E, I, L, N, f, 'pinned', 'pinned');
beam = simple_euler_beam_solver(beam);
fig = beam_visualization(beam, 'Pinned-Pinned');
saveas(fig,'pinned-pinned.png');

%%
% Ex. 5
beam = create_beam(E, I, L, N, f, 'fixed', 'pinned');
beam = simple_euler_beam_solver(beam);
fig = beam_visualization(beam, 'Fixed-Pinned');
saveas(fig,'fixed-pinned.png');

%%
% Ex. 6
beam = create_beam(E, I, L, N, f, 'pinned', 'fixed');
beam = simple_euler_beam_solver(beam);
fig = beam_visualization(beam, 'Pinned-Fixed');
saveas(fig,'pinned-fixed.png');