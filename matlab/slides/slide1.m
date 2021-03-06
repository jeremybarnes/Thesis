function slide1

% slide1.m
% Jeremy Barnes, 25/7/1999
% $Id$

d = dataset(2, 2);
d = datagen(d, 'ring', 50, 0, 0);

figure(1);  clf;

subplot(1, 2, 1);  dataplot(d);  axis square;
subplot(1, 2, 2);  dataplot(d);  axis square;
hold on;

theta = linspace(0, 2*pi, 100);
circ = sqrt(0.125) * exp(i * theta) + 0.5*(i + 1);
plot(circ, 'k-');

