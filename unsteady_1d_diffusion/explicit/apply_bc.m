function u_array = apply_bc(u_array, Delta_x, types, values)

% left-end
if lower(types(1)) == "dirichlet"
    u_array(1) = values(1);
elseif lower(types(1)) == "neumann"
    u_array(1) = u_array(3) - 2*Delta_x * values(1);
end

% right-end
if lower(types(2)) == "dirichlet"
    u_array(end) = values(2);    
elseif lower(types(2)) == "neumann"
    u_array(end) = u_array(end-2) + 2 * Delta_x * values(2);
end

end