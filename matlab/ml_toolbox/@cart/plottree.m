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
