function dataplot(obj, varargin)

% DATAPLOT - generate a plot of a dataset
%
% SYNTAX:
%
% dataplot(obj, 'category0', 'category1', ..., 'option1', 'option2', ...)
%
% This generates a plot of the dataset.  It is generated in the current
% subplot of the current figure.
%
% The 'categoryn' parameters (one for each category) are simply passed
% straight to the plot routine.  For example, specifying 'rx' will plot
% that particular category in red crosses.  These are optional, however. 
%
% The default specifies no colour, but a different symbol (going
% through the symbols listed in 'help plot' one by one.
%
% Other options are all prepended with the '-' symbol to keep them distinct
% from the categoryn parameters.  The options are as follows:
%
%   -legend      - draw a legend

% @dataset/dataplot.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS
if (obj.dimensions > 3)
   error('dataplot: only can plot three or less dimensions');
end

% Set up our data.  To do this, we have to separate it into separate
% vectors for each category, and then plot each of these.  These vectors are
% stored in a cell array.

% Maybe we could do it faster simply by sorting and then splitting it up?

num_categories = numcategories(obj.categories);
plot_symbols = 'ox.+*sdv^<>ph';
plot_colors = 'brgkcmyw';
category_data = cell(num_categories, 3); % row=category, col = [x y opt]

for i=0:num_categories-1
   % Find and select the elements that belong to this category.

   index = find(obj.y_values == i);
   x = obj.x_values(index, :);
   y = obj.y_values(index);

   % Add this information to our category_data structure
   category_data{i+1, 1} = x;
   category_data{i+1, 2} = y;

   % work out the default symbol and colour to plot with
   symbol = plot_symbols(mod(i, length(plot_symbols))+1);
   colour = plot_colors(rem(i, length(plot_symbols))+1);

   category_data{i+1, 3} = [colour symbol];
end

% Now process our arguments to find out if colours and symbol types have
% been specified.

do_legend = 0;
current_plot = 1;

l = length(varargin);
for i=1:l
   arg = varargin{i};
   switch arg
      case '-legend'
	 do_legend = 1;
      otherwise,
	 category_data{current_plot, 3} = arg;
	 current_plot = current_plot + 1;
   end
end

% Finally, do the plot.  The actual plot done depends upon the number of
% dimensions of the data.

for i=0:num_categories-1
   switch obj.dimensions
      case 1
	 % Do a 2d plot, but put all of the data along the Y axis.

	 x = category_data{i+1, 1};
	 y = zeros(length(x), 1);

	 plot(x, y, category_data{i+1, 3});
      
      case 2
	 % Plot our 2D data.  The first variable is mapped onto the x
         % axis; the second onto the y axis

	 x = category_data{i+1, 1}(:, 1);
	 y = category_data{i+1, 1}(:, 2);

	 plot(x, y, category_data{i+1, 3});

      case 3
	 % Plot our 3D data.  The first, second and third variables are
         % mapped onto the x, y and z axes respectively.

	 x = category_data{i+1, 1}(:, 1);
	 y = category_data{i+1, 1}(:, 2);
	 z = category_data{i+1, 1}(:, 3);

	 plot3(x, y, z, category_data{i+1, 3});
   end
   hold on;
end

% Add a legend if we asked for one
if (do_legend)
   legend(char(categories(obj.categories)));
end


% POSTCONDITIONS
check_invariants(obj);
