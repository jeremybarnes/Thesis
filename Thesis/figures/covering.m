function covering

% covering.m
% Jeremy Barnes, 29/9/99
% $Id$

% Draws a picture of a function covering another function.

global EPSFILENAME

figure(1);  clf;  setup_figure;

subplot(1, 2, 1);  setup_axis;
title('(a) \sl{title}');
xlabel('\it{x}');  ylabel('\it{y}');
axis square;

subplot(1, 2, 2);  setup_axis;
title('(b) \sl{title}');
xlabel('\it{x}');  ylabel('\it{y}');
axis square;

% Our function class is the set of 

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');