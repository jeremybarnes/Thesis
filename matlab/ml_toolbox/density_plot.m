function density_plot(cat, x, y, w)

% DENSITY_PLOT plots class weight density
%
% SYNTAX:
%
% density_plot(cat, x, y, [w])
% density_plot(cat, dataset, [w])
%
% This function generates a density plot of a particular class.  The
% x-y plane is divided into a number of square elements, and the total
% amount of weight for each class is the calculated for each element.
%
% These weights are then plotted independently on two colour scales.
%
% Hopefully, a legend for each classifier will be able to be drawn.
% FIXME: more informative comment

% density_plot.m
% Jeremy Barnes, 23/4/1999
% $Id$

% PRECONDITIONS
% FIXME: add these
% x should have 2 columns
% y should have a maximum of cat categories
if (cat ~= 2)
   error('density_plot: currently only works for two categories');
end

% calculate the data ranges
x1 = x(:, 1);
x1min = min(x1); x1max = max(x1);  x1range = x1max - x1min;

x2 = x(:, 2);
x2min = min(x2); x2max = max(x2);  x2range = x2max - x2min;

% set up our cell array to hold our arrays for weight
weightmaps = cell(cat, 1);

for i=1:cat
   weightmaps{i} = zeros(128);
end

% OK, now to transform our x values into index values into our weight
% categories.  The transformation is x1min -> 1, x1max -> 128

x1 = floor((x1 - x1min) .* 127 ./ x1range) + 1;
x2 = 128 - floor((x2 - x2min) .* 127 ./ x2range);

% For each category, add the weight into the appropriate weightmap
% (indexed by the y value)

for i=1:length(y)
   weightmaps{y(i)+1}(x2(i), x1(i)) = weightmaps{y(i)+1}(x2(i), x1(i)) + ...
       w(i);
end

% Take the log, to give a better colour distrubution and stop
% concentrations from stopping all points from showing up.

%for i=1:cat
%   weightmaps{i} = log(weightmaps{i} + 0.000001);
%end

for i=1:cat
   weightmaps{i} = sqrt(weightmaps{i});
end

image_data = twoclass_density_to_color(weightmaps{2}, weightmaps{1});


colormap(twoclass_colormap('white'));

image(image_data);


