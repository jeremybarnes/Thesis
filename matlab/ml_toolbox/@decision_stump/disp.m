function disp(obj)

% DISP method for DATASET object

% @dataset/disp.m
% Jeremy Barnes, 4/4/1999
% $Id$

disp(['    dataset object:']);
disp(['      dimensions = ' int2str(obj.dimensions)]);
disp(['      categories = ' int2str(numcategories(obj.categories))]);
disp(['      numsamples = ' int2str(obj.numsamples)]);
