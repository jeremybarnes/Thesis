function plottree(obj, domain)

% PLOTTREE plot the decision regions of a DECISION_STUMP classifier
%
% SYNTAX:
%
% plottree(obj, [x_max y_max; x_min y_min])
%
% This function plots the decision boundary of a DECISION_STUMP
% classifier.  This is done by plotting a box in each region, with a
% cross through the box.  The colour of the cross is different for each
% category.
%
% The second parameter gives the coordinates of the entire input domain.
% This allows plotting of the whole domain even if data is very sparse.
%
% RESTRICTIONS:
%
% * This routine only works for up to 8 categories.
% * This routine only works for a 2 dimensional input space.

% @decision_stump/plottree.m
% Jeremy Barnes, 25/4/1999
% $Id$


% Work out the co-ordinates ("domain") of each part of our plane
max_domain = domain(1, :);
min_domain = domain(2, :);

left_max = max_domain;
left_max(obj.splitvar) = obj.splitval;

right_min = min_domain;
right_min(obj.splitvar) = obj.splitval;

left_domain = [left_max; min_domain];
right_domain = [max_domain; right_min];

% Plot each half
plot_region(obj.leftcategory, left_domain);
plot_region(obj.rightcategory, right_domain);


