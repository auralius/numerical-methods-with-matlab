function u_matrix = poiseuille_2d_flow(u_matrix, ly, rho, nu, pressure_grad, dy)

r = size(u_matrix,1);
c = size(u_matrix,2);

for col = 2:c-1
    for row = 2:r-1
        x = (row - 2) * dy;
        u_matrix(row, col) = 1 / (rho * nu) * pressure_grad * x / 2 * (x - ly);
    end
end
end