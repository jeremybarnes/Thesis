function disp(obj)

% DISP method for NORMBOOST2 object

% @normboost2/disp.m
% Jeremy Barnes, 19/8/1999
% $Id$

disp(['  normboost2 object:']);
disp_info(obj.normboost, 'inherited');
disp(['    --- normboost2 fields:']);
disp_info(obj);


