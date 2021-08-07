% The sequence: 
function U = apply_bc(U, Delta_x, Delta_y, types, values)

r = size(U,1);
c = size(U,2);

% left-edge
if lower(types(1)) == "dirichlet"
    U(:,1) = repmat(values(1),r,1);
elseif lower(types(1)) == "neumann"
    U(:,1) = U(:,2) - repmat(Delta_x * values(1),r,1);
end

% right-edge
if lower(types(2)) == "dirichlet"
    U(:,end) = repmat(values(2),r,1);    
elseif lower(types(2)) == "neumann"
    U(:,end) = U(:,end-1) + repmat(Delta_x * values(2),r,1);
end

% top-edge
if lower(types(3)) == "dirichlet"
    U(1,:) = repmat(values(3),1,c);
elseif lower(types(3)) == "neumann"
    U(1,:) = U(2,:) - repmat(Delta_y * values(3),1,c);
end

% bottom-edge
if lower(types(4)) == "dirichlet"
    U(end,:) = repmat(values(4),1,c);
elseif lower(types(4)) == "neumann"
    U(end,:) = U(end-1,:) - repmat(Delta_y * values(4),1,c);
end

end