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

x1 = 128 - floor((x1 - x1min) .* 127 ./ x1range);
x2 = floor((x2 - x2min) .* 127 ./ x2range) + 1;

% For each category, add the weight into the appropriate weightmap
% (indexed by the y value)

for i=1:length(y)
   weightmaps{y(i)+1}(x1(i), x2(i)) = weightmaps{y(i)+1}(x1(i), x2(i)) + ...
       w(i);
end

% Take the log, to give a better colour distrubution and stop
% concentrations from stopping all points from showing up.

for i=1:cat
   weightmaps{i} = log(weightmaps{i} + 0.000001);
end

% Find out the number of bits (and therefore colours) to use, based on
% the number of categories.
switch cat
   case 1
      bits = 6;
      colors = 64;
   case 2
      bits = 3;
      colors = 8;
   case 3
      bits = 2;
      colors = 4;
end

% Now we have our weightmaps, we need to scale them, then put them into a
% form that can be used for a colormap.
for i=1:cat
   weightmin = min(min(weightmaps{i}));
   weightmax = max(max(weightmaps{i}));
   weightrange = weightmax - weightmin;
   weightmaps{i} = round((weightmaps{i} - weightmin) .* (colors-1) ./ ...
			 weightrange) .* (colors^(cat-i));
end

% Create our final bitmap, by adding together the weights of our
% weightmaps

finalweight = ones(128);

for i = 1:cat
   finalweight = finalweight + weightmaps{i};
end

colormap(twoclass_colormap('white'));

image(finalweight);

% pcolor(finalweight);



