function cost_slope

% cost_slope.m
% Jeremy Barnes, 29/9/1999
% $Id$

% Show an increasingly steep slope

global EPSFILENAME

figure(1);  clf;  setup_figure;  setup_axis;

xvalues = linspace(-1, 1);
yvalues = exp(-xvalues);

plot(xvalues, yvalues, 'k-');  hold on;
plot([-1 0 0 1], [1 1 0 0], 'k:');

xlabel('Margin \it{\gamma}');
ylabel('Cost \it{c(\gamma)}');

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');

