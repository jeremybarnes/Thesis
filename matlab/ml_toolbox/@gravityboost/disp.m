function disp(obj)

% DISP method for GRAVITYBOOST object

% @gravityboost/disp.m
% Jeremy Barnes, 26/8/1999
% $Id$

name = class(obj);

disp(['  ' name ' object:']);
disp_info(obj.normboost, 'inherited');
disp(['    --- ' name ' fields:']);
disp_info(obj);


