function b_plot(obj, color, nosort)

% B_PLOT plot the B density of a boost object
% 
% SYNTAX:
%
% b_plot(obj, 'color', ['nosort'])
%
% This function plots on the current axes the distribution of the weights
% B of the weak learner.
%
% The plot is made with the colors specified in the COLOR parameter.  If
% none are specified, then 
%
% The weights are sorted first in ascending order, unless the string
% 'nosort' is passed as the final parameter, in which case the weights
% remain unsorted.
%
% From this plot, an idea of the number of important weak learners can be
% gained.  A nearly straight line indicates that all are quite important;
% whereas one that hugs the right of the graph indicates that most of the
% weight is with a few weak learners.

% @p_boost/b_plot.m
% Jeremy Barnes, 21/5/1999
% $Id$

if (nargin == 1)
   color = 'b-';
end

if (nargin == 2)
   nosort = [];
end

if (strcmp(color, 'nosort'))
   color = 'b-';
   nosort = 'nosort';
end

if (~isempty(nosort))
   if (nosort ~= 'nosort')
      error(['b_plot: invalid option name "' nosort '".']);
   end
end

b = obj.b(1:obj.iterations);
b = b ./ sum(b);

if (isempty(nosort))
   b = sort(b);
end

plot(b, color);
