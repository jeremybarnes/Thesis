function disp_info(obj, inherited)

% DISP_INFO disp_info field for GRAVITYBOOST

% @gravityboost/disp_info.m
% Jeremy Barnes, 26/8/1999
% $Id$

if (nargin == 2)
   disp_info(obj.normboost, 'inherited');
   disp(['    --- inherited from gravityboost:']);
end

disp(['      gravity = ' num2str(obj.lambda)]);