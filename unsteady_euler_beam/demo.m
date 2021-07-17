function demo2
    clear
    close all
    clc

    %%
    global N;
    N = 1000;       % Number of segments


    E = 210e9;      % Young's modulus, in Pascal
    L = 2;          % Length, in m
    I = 4e-6;       % Second area of momment inertia, in m^4

    %%
    % Ex.1
    beam = create_beam(E, I, L, N, @f, 'fixed', 'free');
    beam = dynamic_euler_beam_solver(beam, 3);
    fig = dynamic_beam_visualization(beam, 'Fixed-Free');

end

function output = f(k,t)
    global N;
    output = zeros(length(k),1);
    if t == 0
        output(ceil(N/2)) = -40e3;
    end
end


