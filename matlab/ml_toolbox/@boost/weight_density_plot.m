function weight_density_plot(obj, option)

% WEIGHT_DENSITY_PLOT plot the density of weights
%
% SYNTAX:
%
% weight_density_plot(obj)
%
% This function generates a plot of the density of weights for the
% current boosting algorithm, which allows the "important" samples of a
% distribution to be identified.
%
% Basically, it allows the progress of the boosting algorithm to be
% visualised and followed.
%
% weight_density_plot(obj, 'markers') does it with marker size instead of
% bitmaps.  This comes out better for printing.
%
% FIXME:  comment

% @boost/weight_density_plot.m
% Jeremy Barnes, 25/4/1999
% $Id$


if (nargin == 1)
   option = 'bitmap'
end

density_plot(numcategories(obj), x(obj), y(obj), w(obj), option);

