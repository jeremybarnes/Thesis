function optimal_p_value

% optimal_p_value.m
% Jeremy Barnes 12/10/1999
% $Id$

% Show how there must be an optimal p value and that we need to use SRM
% to find it

global EPSFILENAME


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

plot(x, terry, 'k-');  hold on;
plot(x, ciy, 'k--');
plot(x, gey, 'k-', 'linewidth', 2);
plot(mx, my, 'k.', 'markersize', 25);
plot([mx mx], [0 my], 'k:');

set(gca, 'xtick', [0 mx], 'xticklabel', {'0', 'p*'});
set(gca, 'ytick', []);

xlabel('\it{p}');
ylabel('Risk');


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps', '-loose');
