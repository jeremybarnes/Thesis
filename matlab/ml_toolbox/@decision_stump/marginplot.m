function marginplot(obj, domain)

% MARGINPLOT generate a plot of the margins of a classifier
%
% Domain = [xmin, ymin; xmax, ymax]
% FIXME: comment

% @decision_stump/marginplot.m
% Jeremy Barnes, 20/5/1999
% $Id$

num_xpoints = 20;
num_ypoints = 20;

xpoints = linspace(domain(1, 1), domain(2, 1), num_xpoints + 1)';
ypoints = linspace(domain(1, 2), domain(2, 2), num_ypoints + 1)';

bigm = zeros(num_xpoints+1, num_ypoints+1);

for i=1:num_xpoints+1
   % Do a row of Y points

   x_data = [ones(num_ypoints+1, 1) .* xpoints(i) ypoints];
   m = margins(obj, x_data);
   bigm(:, i) = m;
end

surf(ypoints, xpoints, bigm+1);
hold on;
[c, h] = contour(ypoints, xpoints, bigm+1);
colorbar;
shading interp;

