function disp(obj)

% DISP method for DATASET object

% @p_boost/disp.m
% Jeremy Barnes, 25/4/1999
% $Id$

disp(['    p_boost object:']);
disp(['      dimensions    = ' int2str(obj.dimensions)]);
disp(['      categories    = ' int2str(numcategories(obj.categories))]);
disp(['      iterations    = ' int2str(obj.iterations) '/' ...
      int2str(obj.maxiterations)]);
disp(['      p             = ' num2str(obj.p)]);
disp(['      length(x)     = ' int2str(length(obj.x))]);
