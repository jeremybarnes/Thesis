function slide8

% slide8.m
% Jeremy Barnes, 26/7/19999
% $Id$

% This one simply plots the b function against epsilon_t.

epsilon_t = linspace(0.5, 0.99, 50);
b = bfunc(epsilon_t, 0.5);

figure(1);  clf;
plot(epsilon_t, b);
xlabel('epsilon_t');
ylabel('b');
%grid on;
axis([0.5 1.0, 0.0 3.0]);

% White background
set(1, 'Color', [1 1 1]);

