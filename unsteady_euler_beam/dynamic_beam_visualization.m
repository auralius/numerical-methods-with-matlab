function fig = dynamic_beam_visualization(beam, title_text)

fig = figure;
fig.Position = [100 100 640 200];
hold on;

t = {title_text, ' Deflection'};
h_plot = plot(0,0,'b');
ylim([min(min(beam.w)) max(max(beam.w))]);
title(t);
ylabel('m');
xlabel('m');

fn = strcat(title_text, '.gif');

for k = 1 : length(beam.t)
    set(h_plot,'XData',beam.x, 'YData', beam.w(k,:))
    drawnow
    
    write2gif(fig, k, fn);    
end
end