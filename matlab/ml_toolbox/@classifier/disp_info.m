function disp_info(obj, inherited)

% DISP_INFO method for CLASSIFIER object

% @boost/disp.m
% Jeremy Barnes, 19/8/1999
% $Id$

if (nargin == 2)
   disp('    --- inherited from classifier:');
end

disp(['      dimensions    = ' int2str(dimensions(obj))]);
disp(['      numcategories = ' int2str(numcategories(obj))]);
