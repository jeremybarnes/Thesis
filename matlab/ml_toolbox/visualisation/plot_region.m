function plot_region(category, domain)

% PLOT_REGION plot a big cross within a domain
%
% SYNTAX:
%
% plot_region(category, [xmin ymin; xmax ymax])
%
% This function draws a box with a big cross inside within the domain
% specified.  The colour of the box depends upon the value of the
% CATEGORY variable: 0=blue, 1=red, 2=green, 3=black, 4=magenta,
% 5=yellow, 6=cyan, 7=white.
%
% RESTRICTIONS:
%
% * CATEGORY must be less than 8.

% plot_region.m
% Jeremy Barnes, 9/5/1999
% $Id$

x = zeros(1, 8);
xdomain = domain(:, 1);
x(1, 1) = xdomain(1);
x(1, 2) = xdomain(2);
x(1, 3) = xdomain(2);
x(1, 4) = xdomain(1);
x(1, 5) = xdomain(1);
x(1, 6) = xdomain(2);
x(1, 7) = xdomain(2);
x(1, 8) = xdomain(1);

y = zeros(1, 8);
ydomain = domain(:, 2);
y(1, 1) = ydomain(1);
y(1, 2) = ydomain(1);
y(1, 3) = ydomain(2);
y(1, 4) = ydomain(2);
y(1, 5) = ydomain(1);
y(1, 6) = ydomain(2);
y(1, 7) = ydomain(1);
y(1, 8) = ydomain(2);

colors = 'rbgkmycw';

color = [colors(category + 1) '-'];

hold on;
plot(x, y, color);
