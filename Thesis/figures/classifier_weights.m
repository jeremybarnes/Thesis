function classifier_weights

% classifier_weights.m
% Jeremy Barnes, 28/9/19999
% $Id$

% This one simply plots the b function against epsilon_t.

global EPSFILENAME

epsilon_t = linspace(0.01, 0.5, 50);
b = abs(bfunc(epsilon_t, 0.5));

figure(1);  clf;
plot(epsilon_t, b, 'k-');
xlabel('Training error');
ylabel('Classifier weight');
%grid on;
axis([0 0.5, 0.0 3.0]);
axis square;

set(1, 'paperposition', [0 0 6 2.8]);

print(EPSFILENAME, '-f1','-deps');
