%                    40kN
%                     |
% fixed               |   
% ##                  V
% ##===================================== free
% ##                 1m                 2m
%

clear all
close all
clc

E = 210e9;      % Young's modulus, in Pascal
L = 2;          % Length, in m
I = 4e-6;       % Second area of momment inertia, in m^4 

N = 1000;
f = zeros(N,1);
f(ceil(end/2)) = -40e3;
beam = create_beam(E, I, L, N, f, 'fixed', 'free');

beam = simple_euler_beam_solver(beam);
beam_visualization(beam)