function slide9

% slide9.m
% Jeremy Barnes, 26/7/1999
% $Id$

% Generate our surface

[x, y, z] = peaks(29);

firstlinex = [0.1 1.8 -0.2];
firstliney = [1.6 -0.2 -0.5];


figure(1);  clf;
set(1, 'Renderer', 'painters');
surf(x,y,z);  hold on;
theta = linspace(0, 2*pi, 200);
circlex = 2 * sin(theta);
circley = 2 * cos(theta);

draw_on_surface(x, y, z, circlex, circley, 'b-');
draw_on_surface(x, y, z, firstlinex(1), firstliney(1), 'ro');

axis([-2 2 -2 2 -12 12]);
%axis square;
colormap(sqrt(gray));

% White background
set(1, 'Color', [1 1 1]);

function draw_on_surface(sx, sy, sz, fx, fy, linestyle)

% DRAW_ON_SURFACE draw the closed figure given by the points (fx, fy) on the surface (sx, sy, sz).
fz = interp2(sx, sy, sz, fx, fy);
plot3(fx, fy, fz + 0.1, linestyle);




