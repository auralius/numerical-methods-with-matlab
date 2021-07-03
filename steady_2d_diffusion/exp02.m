close all
clear all
clc

a = 1;
b = 1;

p = @(y) 0;
q = @(x) 0;
r = @(y) 100*sin(pi*y);
s = @(x) 0;

f = @(x,y) 0;

h = 0.25;

U = neumann_poisson_solver(p, q, r, s, f, a, b, h);