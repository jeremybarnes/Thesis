function cost_approx

% cost_approx.m
% Jeremy Barnes, 29/9/1999
% $Id$

global EPSFILENAME

figure(1);  clf;  setup_figure;  setup_axis;

xvalues = linspace(-1, 1);
yvalues = exp(-xvalues);

plot(xvalues, yvalues, 'k-');  hold on;
plot([-1 0 0 1], [1 1 0 0], 'k:');

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');
