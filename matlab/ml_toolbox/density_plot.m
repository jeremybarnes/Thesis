function density_plot(cat, x, y, w, option)

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

if (nargin == 4)
   option = 'bitmap';
end

if (strcmp(option, 'markersize'))
   do_density_plot_markersize(cat, x, y, w);
elseif (strcmp(option, 'markercolor'))
   do_density_plot_markercolor(cat, x, y, w);
elseif (strcmp(option, 'bitmap'))
   do_density_plot_bitmap(cat, x, y, w);
else
   error(['Invalid option "' option '".']);
end



function do_density_plot_bitmap(cat, x, y, w)

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
%   weightmaps{i} = sqrt(weightmaps{i});
end

image_data = twoclass_density_to_color(weightmaps{2}, weightmaps{1});


colormap(twoclass_colormap('white'));

s = surface([0 1], [0 1], [0 0; 0 0], 'facecolor', 'texture', 'cdata', ...
      image_data, 'cdatamapping', 'direct');



function do_density_plot_markersize(cat, x, y, w)

% Here, we simply plot one marker per data point, the size depending upon
% the weight.

for i=1:length(y)
   
   w = sqrt(w);
   
   sizes = w ./ max(w) * 25;
   
   plot(x(i, 1), x(i, 2), 'k.', 'markersize', sizes(i));  hold on;
end




function do_density_plot_markercolor(cat, x, y, w)

% Here, we simply plot one marker per data point, the size depending upon
% the weight.

sizes = w ./ max(w);

for i=1:length(y)
   
   c = 1 - sqrt(sizes(i));
%   l = plot(0, 0, 'k.');
%   get(l)
   plot(x(i, 1), x(i, 2), 'k.', 'markeredgecolor', [c c c]);  hold on;
end



