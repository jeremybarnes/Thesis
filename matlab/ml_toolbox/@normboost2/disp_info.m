function disp_info(obj, inherited)

% DISP_INFO disp_info field for NORMBOOST2

% @normboost2/disp_info.m
% Jeremy Barnes, 19/8/1999
% $Id$

if (nargin == 2)
   disp_info(obj.normboost, 'inherited');
   disp(['    --- inherited from normboost2:']);
end
