% The sequence: 
function T = apply_bc(T, Delta_x, Delta_y, types, values)

r = size(T,1);
c = size(T,2);

% left-edge
if lower(types(1)) == "dirichlet"
    T(:,1) = repmat(values(1),r,1);
elseif lower(types(1)) == "neumann"
    T(:,1) = T(:,3) - repmat(2 * Delta_x * values(1),r,1);
end

% right-edge
if lower(types(2)) == "dirichlet"
    T(:,end) = repmat(values(2),r,1);    
elseif lower(types(2)) == "neumann"
    T(:,end) = T(:,end-2) + repmat(2 * Delta_x * values(2),r,1);
end

% top-edge
if lower(types(3)) == "dirichlet"
    T(1,:) = repmat(values(3),1,c);
elseif lower(types(3)) == "neumann"
    T(1,:) = T(3,:) - repmat(2 * Delta_y * values(3),1,c);
end

% bottom-edge
if lower(types(4)) == "dirichlet"
    T(1,:) = repmat(values(4),1,c);
elseif lower(types(4)) == "neumann"
    T(end,:) = T(end-2,:) - repmat(2 * Delta_y * values(4),1,c);
end

end