function plot_decision_boundary(obj, domain)

% PLOT_DECISION_BOUNDARY generate a plot of the margins of a classifier
%
% Domain = [xmin, ymin; xmax, ymax]
% FIXME: comment

% @classifier/plot_decision_boundary.m
% Jeremy Barnes, 20/5/1999
% $Id$

num_xpoints = 100;
num_ypoints = 100;

xpoints = linspace(domain(1, 1), domain(2, 1), num_xpoints + 1)';
ypoints = linspace(domain(1, 2), domain(2, 2), num_ypoints + 1)';

bigm = zeros(num_xpoints+1, num_ypoints+1);

for i=1:num_xpoints+1
   % Do a row of Y points

   x_data = [ones(num_ypoints+1, 1) .* xpoints(i) ypoints];
   m = margins(obj, x_data);
   c = classify(obj, x_data);

   m = (2 * c - 1) .* m;

   bigm(:, i) = m;
end

if (max(bigm) != min(bigm))
   [c, h] = contour(ypoints, xpoints, bigm+1, [1 1]);
end

