function disp(obj)

% DISP method for BOOST object

% @boost/disp.m
% Jeremy Barnes, 25/4/1999
% $Id$

disp(['    boost object:']);
disp(['      dimensions    = ' int2str(obj.dimensions)]);
disp(['      categories    = ' int2str(numcategories(obj.categories))]);
disp(['      iterations    = ' int2str(obj.iterations)]);

