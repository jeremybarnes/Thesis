function plotboundary(obj, domain)

% PLOTBOUNDARY plot the decision boundary of a DECISION_STUMP classifier
%
% SYNTAX:
%
% plottree(obj, [x_max y_max; x_min y_min])
%
% This function plots the decision boundary of a DECISION_STUMP
% classifier.
%
% The second parameter gives the coordinates of the entire input domain.
% This allows plotting of the whole domain even if data is very sparse.
%
% RESTRICTIONS:
%
% * This routine only works for a 2 dimensional input space.

% @decision_stump/plotboundary.m
% Jeremy Barnes, 25/4/1999
% $Id$


% Work out the co-ordinates ("domain") of each part of our plane
max_domain = domain(1, :);
min_domain = domain(2, :);

if (obj.splitvar == 1)
   plot([obj.splitval obj.splitval], [min_domain(2), max_domain(2)], 'k--');
else
   plot([min_domain(1), max_domain(1)], [obj.splitval obj.splitval], 'k--');
end
