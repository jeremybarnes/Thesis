function naive

% classifier_weights.m
% Jeremy Barnes, 28/9/19999
% $Id$

% This one simply plots the b function against epsilon_t.

global EPSFILENAME

epsilon_t = linspace(0.01, 0.5, 50);
b1 = abs(bfunc(epsilon_t, 0.5));  
b7 = abs(bfunc(epsilon_t, 0.5)).^(1/0.7);
b5 = abs(bfunc(epsilon_t, 0.5)).^(1/0.5);

figure(1);  clf;  setup_figure;  setup_axis;
plot(epsilon_t, b1, 'k-');  hold on;
plot(epsilon_t, b7, 'k:');
plot(epsilon_t, b5, 'k--');
xlabel('\epsilon_t');
ylabel('b_t');
axis([0 0.5, 0.0 3.0]);
axis square;

t= text(0.18, 2.8, '\it{p}=0.5', 'fontname', 'times');
t= text(0.11, 2.6, '\it{p}=0.7', 'fontname', 'times');
t= text(0.04, 2.4, '\it{p}=1', 'fontname', 'times');

set(1, 'paperposition', [0 0 4 2.5]);

print(EPSFILENAME, '-f1','-deps');
