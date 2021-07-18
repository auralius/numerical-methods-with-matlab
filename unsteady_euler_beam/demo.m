function demo
    clear
    close all
    clc

    %%
    global N;
    N = 50;       % Number of segments


    E = 210e9;      % Young's modulus, in Pascal
    L = 1;          % Length, in m
    I = 4e-6;       % Second area of momment inertia, in m^4
    
    tsim = 2;

    %%
    % Ex.1
    beam = create_beam(E, I, L, N, @f, 'fixed', 'free');
    beam = dynamic_euler_beam_solver(beam, tsim);
    fig = dynamic_beam_visualization(beam, 'Fixed-Free');
    
    % Ex.2
    beam = create_beam(E, I, L, N, @f, 'fixed', 'fixed');
    beam = dynamic_euler_beam_solver(beam, tsim);
    fig = dynamic_beam_visualization(beam, 'Fixed-Fixed');
    
    % Ex.3
    beam = create_beam(E, I, L, N, @f, 'fixed', 'pinned');
    beam = dynamic_euler_beam_solver(beam, tsim);
    fig = dynamic_beam_visualization(beam, 'Fixed-Pinned');
    
    % Ex.4
    beam = create_beam(E, I, L, N, @f, 'pinned', 'fixed');
    beam = dynamic_euler_beam_solver(beam, tsim);
    fig = dynamic_beam_visualization(beam, 'Pinned-Fixed');
    
    % Ex.5
    beam = create_beam(E, I, L, N, @f, 'pinned', 'pinned');
    beam = dynamic_euler_beam_solver(beam, tsim);
    fig = dynamic_beam_visualization(beam, 'Pinned-Pinned');

end

function output = f(k,t)
    global N;
    output = zeros(length(k),1);
    if t == 0
        output(ceil(N/2)) = -40e3;
    end
end


