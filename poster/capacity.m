% capacity.m
% Jeremy Barnes, 28/10/1999
% $Id:$

% This file draws three graphs which show capacity control (in a
% regression setting)

target_poly = [1 0 -1 2];

xsamples = rand(1, 20)*4-2;

ysamples = polyval(target_poly, xsamples) + randn(size(xsamples))*0.5;

allx = linspace(-2, 2);
ally = polyval(target_poly, allx);

right_poly = polyfit(xsamples, ysamples, 3);
toolittle_poly = polyfit(xsamples, ysamples, 2);
toomuch_poly = polyfit(xsamples, ysamples, 12);


righty = polyval(right_poly, allx);
littley = polyval(toolittle_poly, allx);
muchy = polyval(toomuch_poly, allx);

figure(1);  clf;
plot(xsamples, ysamples, 'r.', 'markersize', 25);  hold on;
%plot(allx, righty, 'k--', 'linewidth', 2);
plot(allx, ally, 'b-', 'linewidth', 2);
set(gca, 'xtick', [], 'ytick', []);
%xlabel('x');; ylabel('y');
ax = axis;




figure(2);  clf;
plot(xsamples, ysamples, 'r.', 'markersize', 25);  hold on;
%plot(allx, righty, 'k--', 'linewidth', 2);
plot(allx, littley, 'b-', 'linewidth', 2);
set(gca, 'xtick', [], 'ytick', []);
%xlabel('x');; ylabel('y');
axis(ax);


figure(3);  clf;
plot(xsamples, ysamples, 'r.', 'markersize', 25);  hold on;
%plot(allx, righty, 'k--', 'linewidth', 2);
plot(allx, muchy, 'b-', 'linewidth', 2);
set(gca, 'xtick', [], 'ytick', []);
%xlabel('x');; ylabel('y');
axis(ax);





