function overfitting

% overfitting.m
% Jeremy Barnes 28/10/1999
% $Id: optimal_p_value.m,v 2.0 1999/10/25 07:41:55 jeremy Exp $

% Another figure for my poster

figure(1);  clf;  setup_figure;  setup_axis;

terru = [0.0 0.5 1.0];
terrv = [0.5 0.1 0.01];

ciu = [0.0 0.5 1.0];
civ = [0.1 0.2 0.7];

x = linspace(0, 1, 51);
%terry = interp1(terru, terrv, x, 'cubic');
terry = 0.1 ./ (x+0.3);
ciy = interp1(ciu, civ, x, 'cubic');
gey = terry + ciy;

my = min(gey);
i = find(gey == my);
i = i(1);
mx = x(i);

ax = 0.1;
a = find(x == ax);
ay = gey(a);

bx = 0.8;
b = find(x == bx);
by = gey(b);



plot(x, gey, 'k-', 'linewidth', 2);  hold on;

plot(mx, my, 'k.', 'markersize', 25);
plot([mx mx], [0 my], 'k:');

plot(ax, ay, 'k.', 'markersize', 25);
plot([ax ax], [0 ay], 'k:');

plot(bx, by, 'k.', 'markersize', 25);
plot([bx bx], [0 by], 'k:');

set(gca, 'xtick', [ax mx bx], ...
	 'xticklabel', {'Under', 'Optimal', 'Over'});
set(gca, 'ytick', []);

xlabel('Capacity');
ylabel('Error');


