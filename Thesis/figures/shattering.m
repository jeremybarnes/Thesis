function shattering

% shattering.m
% Jeremy Barnes, 26/9/1999
% $Id$

% Draws a diagram of shattering

global EPSFILENAME

figure(1);  clf;

two_points_x = [0.2 0.8];
two_points_y = [0.8 0.2];

three_points_x = [0.2 0.8 0.4];
three_points_y = [0.2 0.2 0.8];

figure(1);  clf;

subplot(1, 2, 1);
plot(two_points_x, two_points_y, 'k.', 'MarkerSize', 10);  hold on;
plot([0 1], [0 1], 'k--');
plot([0.2 1], [1 0.8], 'k--');
plot([0 0.8], [0.8 0], 'k--');
plot([0.5 0.5], [0 1], 'k--');
title('(a)');
axis square;

subplot(1, 2, 2);
plot(three_points_x, three_points_y, 'k.', 'MarkerSize', 10);
axis([0 1 0 1]);
title('(b)');
axis square;

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');