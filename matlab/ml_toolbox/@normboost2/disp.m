function disp(obj)

% DISP method for NORMBOOST object

% @normboost/disp.m
% Jeremy Barnes, 19/8/1999
% $Id$

disp(['  normboost object:']);
disp_info(obj.boost, 'inherited');
disp(['    --- normboost fields:']);
disp_info(obj);


