function slide2

% slide2.m
% Jeremy Barnes, 25/7/1999
% $Id$

d = dataset(2, 2);
d = datagen(d, 'chess4x4', 50, 0, 0);

figure(1);  clf;

subplot(1, 2, 1);  dataplot(d);  axis square;
subplot(1, 2, 2);  dataplot(d);  axis square;
hold on;

% Horizontal lines
for i=1:3
   plot([0 1], [0.25*i 0.25*i], 'k-');
end

for i=1:3
   plot([0.25*i 0.25*i], [0 1], 'k-');
end

% White background
set(1, 'Color', [1 1 1]);
