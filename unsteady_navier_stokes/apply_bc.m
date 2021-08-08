% The sequence: 
function U = apply_bc(U, dx, dy, types, values)

nr = size(U,1);
nc = size(U,2);

% left-edge
if lower(types(1)) == "dirichlet"
    U(:,1:2) = repmat(values(1),nr,2);
elseif lower(types(1)) == "neumann"
    U(:,1) = U(:,3) - repmat(2 * dx * values(1),nr,1);
end

% right-edge
if lower(types(2)) == "dirichlet"
    U(:,end-1:end) = repmat(values(2),nr,2);    
elseif lower(types(2)) == "neumann"
    U(:,end) = U(:,end-2) + repmat(2 * dx * values(2),nr,1);
end

% top-edge
if lower(types(3)) == "dirichlet"
    U(1:2,:) = repmat(values(3),2,nc);
elseif lower(types(3)) == "neumann"
    U(1,:) = U(3,:) - repmat(2 * dy * values(3),1,nc);
end

% bottom-edge
if lower(types(4)) == "dirichlet"
    U(end-1:end,:) = repmat(values(4),2,nc);
elseif lower(types(4)) == "neumann"
    U(end,:) = U(end-2,:) - repmat(2 * dy * values(4),1,nc);
end

end