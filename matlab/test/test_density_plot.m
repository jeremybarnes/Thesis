function test_density_plot(datatype, numpoints)

% TEST_DENSITY_PLOT generate a dataset and plot its density
%
% SYNTAX:
%
% test_density_plot('datatype', numpoints)
%
% DATATYPE controls the distribution from which the points are drawn.
% The possible values are those listed in the @dataset/datagen function.
%
% NUMPOINTS specifies the number of points to be plotted.

% test_density_plot.m
% Jeremy Barnes, 24/4/1999
% $Id$

b = category_list('binary');
d = dataset(b, 2);

d = datagen(d, datatype, numpoints, 0, 0);

[x, y] = data(d);

%w = rand(size(y));
w = ones(size(y));

density_plot(2, x, y, w);

