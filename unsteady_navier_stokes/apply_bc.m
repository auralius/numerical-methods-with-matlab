function U = apply_bc(U, dx, dy, types, values)

nr = size(U,1);
nc = size(U,2);

% left (i = 1)
if lower(types(1)) == "dirichlet"
    U(:,1) = values(1);
elseif lower(types(1)) == "neumann"
    U(:,1) = U(:,2) - dx * values(1);
end

% right (i = nc)
if lower(types(2)) == "dirichlet"
    U(:,nc) = values(2);
elseif lower(types(2)) == "neumann"
    U(:,nc) = U(:,nc-1) + dx * values(2);
end

% top (j = 1)
if lower(types(3)) == "dirichlet"
    U(1,:) = values(3);
elseif lower(types(3)) == "neumann"
    U(1,:) = U(2,:) - dy * values(3);
end

% bottom (j = nr)
if lower(types(4)) == "dirichlet"
    U(nr,:) = values(4);
elseif lower(types(4)) == "neumann"
    U(nr,:) = U(nr-1,:) + dy * values(4);
end

end
