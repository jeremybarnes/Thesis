function marginplot(obj, domain)

% MARGINPLOT generate a plot of the margins of a classifier
%
% Domain = [xmin, ymin; xmax, ymax]
% FIXME: comment

% @classifier/marginplot.m
% Jeremy Barnes, 20/5/1999
% $Id$

num_xpoints = 50;
num_ypoints = 50;

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

surf(ypoints, xpoints, bigm+1);
hold on;
if (max(bigm) != min(bigm))
   [c, h] = contour(ypoints, xpoints, bigm+1, [1 1]);
end
colorbar;
shading interp;

