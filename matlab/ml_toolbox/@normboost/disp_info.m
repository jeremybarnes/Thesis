function disp_info(obj, inherited)

% DISP_INFO disp_info field for NORMBOOST

% @normboost/disp_info.m
% Jeremy Barnes, 19/8/1999
% $Id$

if (nargin == 2)
   disp_info(obj.boost, 'inherited');
   disp(['    --- inherited from normboost:']);
end

disp(['      norm          = ' int2str(norm(obj))]);
