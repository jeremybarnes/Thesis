function disp(obj)

% DISP method for BOOST object

% @boost/disp.m
% Jeremy Barnes, 25/4/1999
% $Id$

disp(['  boost object:']);
disp_info(obj.classifier, 'inherited');
disp(['    --- boost fields:']);
disp_info(obj);


