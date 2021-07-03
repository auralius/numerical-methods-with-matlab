function  beam = compute_moment_and_shear_force(beam)

w_dot = medfilt1(diff(beam.w) ./ beam.dx, ceil(beam.N/100));
w_ddot = medfilt1(diff(w_dot) ./ beam.dx, ceil(beam.N/100));
w_dddot = medfilt1(diff(w_ddot) ./ beam.dx, ceil(beam.N/100));


beam.shear_force = w_dddot .* (beam.E * beam.I);
beam.moment = w_ddot .* (beam.E * beam.I);

end