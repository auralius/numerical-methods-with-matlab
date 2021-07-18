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

htext = text(beam.length/2, min(min(beam.w)/2), 'Time=');
htext.FontWeight = 'bold';

fn = strcat(title_text, '.gif');

for k = 1 : length(beam.t)
    set(h_plot,'XData',beam.x, 'YData', beam.w(k,:))
    htext.String = ['Time=', num2str(beam.t(k)), 's'] ;
    drawnow
    
    write2gif(fig, k, fn);    
end
end