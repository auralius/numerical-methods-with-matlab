function beam_visualization(beam)
figure 

subplot(3,1,1);
hold on;
plot(beam.x, zeros(beam.N,1),'--b')
plot(beam.x, beam.w,'r')
title('Deflection')
ylabel('m');
xlabel('m')

subplot(3,1,2);
plot(beam.x(1:end-3), beam.shear_force,'b')
title('Shear Force')
ylabel('N');
xlabel('m')

subplot(3,1,3);
plot(beam.x(1:end-2), beam.moment,'b')
title('Moment')
ylabel('Nm');
xlabel('m')

end