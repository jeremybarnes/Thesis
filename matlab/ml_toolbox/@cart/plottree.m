function plottree(obj, domain)

% FIXME comment
% only works for 2D, of course
% currently also only for binary classifiers
%
% domain is [x_max y_max; x_min y_min]

% @cart/printtree.m
% Jeremy Barnes, 6/4/1999
% $Id$

recursive_plot(obj.tree, domain);





function recursive_plot(tree, domain)

if (isa(tree, 'double'))
   % If it is a terminal node, plot a big cross in the domain
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

   if (tree == 0)
      color = 'b-';
   else
      color = 'r-';
   end
      
   hold on;
   plot(x, y, color);
else
   % Otherwise, calculate our domain and plot the left and right subtrees
   max_domain = domain(1, :);
   min_domain = domain(2, :);

   left_max = max_domain;
   left_max(tree.splitvar) = tree.splitval;

   right_min = min_domain;
   right_min(tree.splitvar) = tree.splitval;

   left_domain = [left_max; min_domain];
   right_domain = [max_domain; right_min];

   recursive_plot(tree.left, left_domain);
   recursive_plot(tree.right, right_domain);
end
function plottree(obj, domain)

% PLOTTREE plot the decision regions of a CART classifier
%
% SYNTAX:
%
% plottree(obj, [x_max y_max; x_min y_min])
%
% This function plots the decision regions of a CART classifier.  This is
% done by plotting a box in each region, with a cross through the box.
% The colour of the cross is different for each category.
%
% The second parameter gives the coordinates of the entire input domain.
% This allows plotting of the whole domain even if data is very sparse.
%
% RESTRICTIONS:
%
% * This routine only works for up to 8 categories.
% * This routine only works for a 2 dimensional input space.

% @cart/plottree.m
% Jeremy Barnes, 6/4/1999
% $Id$


% This is done in a recursive manner, in the routine below.
recursive_plot(obj.tree, domain);





function recursive_plot(tree, domain)

% RECURSIVE_PLOT traverse the tree, plotting terminal nodes


if (tree.isterminal)
   % If it is a terminal node, plot a big cross in the domain
   plot_region(tree.category, domain);

else
   % Otherwise, calculate our domain and plot the left and right subtrees
   max_domain = domain(1, :);
   min_domain = domain(2, :);

   left_max = max_domain;
   left_max(tree.splitvar) = tree.splitval;

   right_min = min_domain;
   right_min(tree.splitvar) = tree.splitval;

   left_domain = [left_max; min_domain];
   right_domain = [max_domain; right_min];

   recursive_plot(tree.left, left_domain);
   recursive_plot(tree.right, right_domain);
end
