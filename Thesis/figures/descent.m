function descent

% DESCENT draw a diagram of gradient descent

% descentdiagram.m
% Jeremy Barnes, 15/7/1999
% $Id$

global EPSFILENAME

% Generate our surface

[x, y, z] = peaks(19);


% First up, calculate where everything should go.

firstlinex = [0.1 1.8 -0.2];
firstliney = [1.6 -0.2 -0.5];

y2 = firstliney(2);
y1 = firstliney(1);
x2 = firstlinex(2);
x1 = firstlinex(1);

m = (y2 - y1) / (x2 - x1);
n = 1/m;
r = 2;

% This equation solves for where the line that passes through (x1, y1) and (x2, y2)intersects
% the circle at the origin with radius r.
xr = roots([1 + m^2, 2 * y1 * m - 2 * x1 * m^2, y1^2 - 2 * y1 * m * x1 + m^2 * x1^2 - r^2]);
yr = roots([1 + n^2, 2 * x1 * n - 2 * y1 * n^2, x1^2 - 2 * x1 * n * y1 + n^2 * y1^2 - r^2]);

% Generate a whole bunch of points along that line...

x1 = xr(1);  y1 = yr(2);  	% reversed as roots returns them that way
x2 = xr(2);  y2 = yr(1);

xl = linspace(x1, x2, 100);
yl = y1 + m * (xl - x1);

% Find the minimum value along that line
x;
y;
z;
zl = interp2(x, y, z, xl, yl);
i = find(zl == min(zl));
i = 50;
xmin = xl(i);
ymin = yl(i);

% Same for the second line

y2 = firstliney(3);
y1 = ymin;
x2 = firstlinex(3);
x1 = xmin;

m = (y2 - y1) / (x2 - x1);
n = 1/m;
r = 2;

% This equation solves for where the line that passes through (x1, y1) and (x2, y2)intersects
% the circle at the origin with radius r.
xr = roots([1 + m^2, 2 * y1 * m - 2 * x1 * m^2, y1^2 - 2 * y1 * m * x1 + m^2 * x1^2 - r^2]);
yr = roots([1 + n^2, 2 * x1 * n - 2 * y1 * n^2, x1^2 - 2 * x1 * n * y1 + n^2 * y1^2 - r^2]);

% Generate a whole bunch of points along that line...

x1 = xr(1);  y1 = yr(2);  	% reversed as roots returns them that way
x2 = xr(2);  y2 = yr(1);

xl2 = linspace(x1, x2, 100);
yl2 = y1 + m * (xl2 - x1);

% Find the minimum value along that line
zl2 = interp2(x, y, z, xl2, yl2);
i = find(zl2 == min(zl2));
i = 40;
xmin2 = xl2(i);
ymin2 = yl2(i);


figure(1);  clf;  subplot(1, 2, 1);
set(1, 'Renderer', 'painters');
surf(x,y,z);  hold on;
theta = linspace(0, 2*pi, 200);
circlex = 2 * sin(theta);
circley = 2 * cos(theta);

draw_on_surface(x, y, z, circlex, circley, 'b-');
draw_on_surface(x, y, z, xl, yl, 'r-');
draw_on_surface(x, y, z, xl2, yl2, 'r-');
draw_on_surface(x, y, z, firstlinex(1), firstliney(1), 'ro');
draw_on_surface(x, y, z, xmin, ymin, 'rs');
draw_on_surface(x, y, z, xmin2, ymin2, 'rd');

axis([-2 2 -2 2 -16 16]);
axis square;
colormap white;
title('(a)');

subplot(1, 2, 2);
[x, y, z] = peaks(49);
pcolor(x, y, z);  hold on;

plot(circlex, circley, 'b-');
axis([-2 2 -2 2 -16 16]);
shading flat;
colormap(sqrt(gray));
axis square;
title('(b)');

plot(xl, yl, 'r-');
plot(xl2, yl2, 'r-');
plot(firstlinex(1), firstliney(1), 'ro');
plot(xmin, ymin, 'rs');
plot(xmin2, ymin2, 'rd');

set(1, 'paperposition', [0 0 7 3]);
print(EPSFILENAME, '-depsc', '-f1');

function draw_on_surface(sx, sy, sz, fx, fy, linestyle)

% DRAW_ON_SURFACE draw the closed figure given by the points (fx, fy) on the surface (sx, sy, sz).
fz = interp2(sx, sy, sz, fx, fy);
plot3(fx, fy, fz + 0.5, linestyle);


