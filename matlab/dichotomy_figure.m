function dichotomy_figure

% DICHOTOMY_FIGURE draw a figure showing a dichotomy

% dichotomy_figure.m
% Jeremy Barnes, 27/5/1999
% $Id$

y_data = [0.1 0.3 0.4 0.6 0.8 0.25 0.68];
x_data = [0.8 0.4 0.6 0.9 0.35 0.15 0.5];

x_points = linspace(0, 1, 101);


figure(1);  clf;
subplot(1, 2, 1);

plot(x_points, func1(x_points), 'k-');
hold on;

index = find(y_data > func1(x_data));
plot(x_data(index), y_data(index), 'ko');

index = find(y_data <= func1(x_data));
plot(x_data(index), y_data(index), 'kx');

axis equal;
axis([0 1 0 1]);
title('(a)');



subplot(1, 2, 2);

plot(x_points, func2(x_points), 'k-');
hold on;
index = find(y_data > func2(x_data));
plot(x_data(index), y_data(index), 'ko');

index = find(y_data <= func2(x_data));
plot(x_data(index), y_data(index), 'kx');


axis equal;
axis([0 1 0 1]);
title('(b)');


set(1, 'PaperUnits', 'inches', 'PaperPosition', [0 0 6 3]);
print -deps e:\Uni\engn4000\Thesis\figures\dichotomy.eps



function y = func1(x)

coeff = [-0.8 2 -1 0.3];

y = polyval(coeff, x);



function y = func2(x)

coeff = [0.5 -2 2 0];

y = polyval(coeff, x);

