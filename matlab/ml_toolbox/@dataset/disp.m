function disp(obj)
% DISP method for DATASET object

% @classlabel/disp.m
% Jeremy Barnes, 4/4/1999
% $Id$

disp(['    dataset object:']);
disp(['      dimensions = ' int2str(obj.dimensions)]);
disp(['      categories = ' int2str(numlabels(obj.labels))]);
disp(['      numsamples = ' int2str(obj.numsamples)]);
