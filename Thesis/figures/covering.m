function covering

% covering.m
% Jeremy Barnes, 29/9/99
% $Id$

% Draws a picture of a function covering another function.

global EPSFILENAME

figure(1);  clf;  setup_figure;

subplot(1, 2, 1);  setup_axis;
title('(a) \sl{Geometric representation}');
xlabel('\it{x_1}');  ylabel('\it{x_2}');

px = [0.30 0.55 0.45 0.75 0.65 0.25 0.30];
py = [0.80 0.75 0.50 0.30 0.20 0.35 0.80];

patch(px, py, [0.8 0.8 0.8]);  hold on;

epsilon = 0.18;

draw_epsilon_box(0.40, 0.70, epsilon);
draw_epsilon_box(0.35, 0.40, epsilon);
draw_epsilon_box(0.60, 0.30, epsilon);

draw_arrow(0.4, 0.7, 0.4, 1.0);
text(0.45, 0.84, '\epsilon');


axis square;
axis([0 1 0 1]);

set(gca, 'xtick', [], 'ytick', []);

subplot(1, 2, 2);  setup_axis;

% We use cubic interpolation to draw our curves

ctrl_x_1 = [0.00 0.33 0.50 0.66 1.00];
ctrl_y_1 = [0.95 0.30 0.70 0.20 0.95];

ctrl_x_2 = [0.00 0.33 0.66 1.00];
ctrl_y_2 = [0.25 0.45 0.25 0.25];

% Get our x vector
x = linspace(0, 1);

% Calculate our two curves
y1 = interp1(ctrl_x_1, ctrl_y_1, x, 'spline');
y2 = interp1(ctrl_x_2, ctrl_y_2, x, 'spline');

% Plot me baby
plot([0 1], [0.25 0.25], 'k-', 'linewidth', 2);  hold on;
plot([0.33 0.66], [0.25 0.25], 'k.', 'markersize', 10);
plot(x, y1, 'k-');
plot(x, y2, 'k--');

% Draw our epsilon bars either side

epsilon = 0.1;
plot([0.33 0.33], [0.25 + epsilon 0.25 - epsilon], 'k:');
plot([0.33 0.33], [0.25 + epsilon 0.25 - epsilon], 'k+');
plot([0.66 0.66], [0.25 + epsilon 0.25 - epsilon], 'k:');
plot([0.66 0.66], [0.25 + epsilon 0.25 - epsilon], 'k+');

text(0.36, 0.20, '\epsilon', 'fontname', 'times');
text(0.68, 0.30, '\epsilon', 'fontname', 'times');

text(0.10, 0.70, '\it{f_1(x)}', 'fontname', 'times');
text(0.20, 0.52, '\it{f_2(x)}', 'fontname', 'times');
text(0.10, 0.20, '\it{g(x)}', 'fontname', 'times');

axis square;
axis([0 1 0 1]);

title('(b) \sl{Covering a function class}');
xlabel('\it{x}');  ylabel('\it{y}');
set(gca, 'xtick', [], 'ytick', []);

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc', '-loose', '-adobecset');



function draw_epsilon_box(x, y, epsilon)

% draw a box with an x in the centre

plot(x, y, 'kx');
l = x - epsilon;  r = x + epsilon;  t = y + epsilon;  b = y - epsilon;
plot([l l r r l], [b t t b b], 'k:');



function draw_arrow(x1, y1, x2, y2)

quiver([x1 x2], [y1 y2], [x2 - x1 0], [y2 - y1 0], 'k-');


function draw_twohead_arrow(x1, y1, x2, y2)

cx = (x1 + x2) ./ 2;  dx = (x2 - x1) ./ 2;
cy = (y1 + y2) ./ 2;  dy = (y2 - y1) ./ 2;

draw_arrow(cx, cy, cx+dx, cy+dy);
draw_arrow(cx, cy, cx-dx, cy-dy);

%quiver([cx cx x1+dx], [cy cy y1], [-dx dx 0], [-dy dy 0], 'k-');

