function b_plot(obj, color)

% B_PLOT plot the B function of a boost object
% FIXME: comment

% @p_boost/b_plot.m
% Jeremy Barnes, 21/5/1999
% $Id$

if (nargin == 1)
   color = 'b-';
end

b = obj.b(1:obj.iterations);
b = b ./ sum(b);
b = sort(b);

plot(b, color);
