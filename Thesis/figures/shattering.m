function shattering

% shattering.m
% Jeremy Barnes, 26/9/1999
% $Id$

% Draws a diagram of shattering

global EPSFILENAME


three_points_x = [0.2 0.8 0.3];
three_points_y = [0.8 0.2 0.1];

four_points_x = [0.2 0.8 0.4];
four_points_y = [0.2 0.2 0.8];

figure(1);  clf;
setup_figure;

subplot(1, 2, 1);  setup_axis;
plot(three_points_x, three_points_y, 'k.', 'MarkerSize', 15);  hold on;
plot([0 1], [0 1], 'k--');
plot([0 0.8], [0.8 0], 'k--');
plot([0.5 0.5], [0 1], 'k--');
title('(a) \sl{Three points}');
set(gca, 'xtick', [], 'ytick', []);
xlabel('\itx_1');  ylabel('\itx_2');
axis square;

subplot(1, 2, 2);  setup_axis;
plot([0.3 0.7], [0.5 0.5], 'k.', 'markersize', 15);  hold on;
plot([0.5 0.5], [0.3 0.7], 'ko');
axis([0 1 0 1]);
xlabel('\itx_1');  ylabel('\itx_2');
set(gca, 'xtick', [], 'ytick', []);
title('(b) \sl{Four points}');
axis square;

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');