function b_func

% b_func.m
% Jeremy Barnes, 24/10/1999
% $Id$

global EPSFILENAME

epsilon_t = linspace(0.0001, 0.5, 500);
b = abs(bfunc(epsilon_t, 0.5));

figure(1);  clf;  setup_figure;  setup_axis;
plot(epsilon_t, b, 'k-');
xlabel('Training error \it{\epsilon_t}');
ylabel('Classifier weight \it{b_t}');
%grid on;
axis([0 0.5, 0.0 10.0]);
axis square;


set(1, 'paperposition', [0 0 4 3]);

print(EPSFILENAME, '-f1','-deps2');