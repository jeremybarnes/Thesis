function strict_search

% p_convex.m
% Jeremy Barnes 27/7/1999
% $Id$


global EPSFILENAME


figure(1);  clf;  setup_figure;

subplot(1, 2, 1);  setup_axis;

a = linspace(0, 1, 101);

p = 0.7;
b = (1 - a.^p).^(1/p);
   
plot(a, b, 'k:');  hold on;
plot(a(50), b(50), 'k.', 'markersize', 15);
quiver([a(50)+0.05 a(50)+0.05 a(50) + 0.2], ...
       [b(50)+0.05 b(50)+0.05 b(50) + 0.2], ...
       [-0.6 0.6 0], [0.5 -0.5 0], 'k-');

axis([0 1.1 0 1.1]);
axis square;
ylabel('\it{F_t}');
xlabel('\it{f_{t+1}}');
title('(a) \sl{Strict \it{p}-boost}');


subplot(1, 2, 2);  setup_axis;

plot([0 0.9], [1 1], 'k:');  hold on;
plot(0.5, 1, 'k.', 'markersize', 15);
quiver([0.5 0.5 0.7], ...
       [0.9 0.9 1.0], ...
       [-1 1 0], [0 0 0], 'k-');
quiver([0.9 1.1], [1 1], [1 0], [0 1], 'k-');

axis([0 1.1 0 1.1]);
axis square;
ylabel('\it{F_t}');
xlabel('\it{f_{t+1}}');
title('(b) \sl{AdaBoost}');


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');
