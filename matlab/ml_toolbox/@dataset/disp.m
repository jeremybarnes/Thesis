function disp(obj)

% DISP method for DATASET object

% @dataset/disp.m
% Jeremy Barnes, 4/4/1999
% $Id$

disp(['    dataset object:']);
disp(['      dimensions    = ' int2str(obj.dimensions)]);
disp(['      numcategories = ' int2str(obj.numcategories)]);
disp(['      numsamples    = ' int2str(obj.numsamples)]);
