function plot_domain(domain)

% PLOT_REGION plot a domain
%
% SYNTAX:
%
% plot_domain([xmin ymin; xmax ymax])
%
% This function draws a box within the domain
% specified.

% plot_domain.m
% Jeremy Barnes, 9/5/1999
% $Id$

x = zeros(1, 5);
xdomain = domain(:, 1);
x(1, 1) = xdomain(1);
x(1, 2) = xdomain(2);
x(1, 3) = xdomain(2);
x(1, 4) = xdomain(1);
x(1, 5) = xdomain(1);

y = zeros(1, 5);
ydomain = domain(:, 2);
y(1, 1) = ydomain(1);
y(1, 2) = ydomain(1);
y(1, 3) = ydomain(2);
y(1, 4) = ydomain(2);
y(1, 5) = ydomain(1);

hold on;
plot(x, y, 'k--');
