function disp(obj)

% DISP method for P_BOOST object

% @p_boost/disp.m
% Jeremy Barnes, 25/4/1999
% $Id$

disp(['  p_boost object:']);
disp_info(obj.boost, 'inherited');
disp(['    --- p_boost fields:']);
disp_info(obj);
