function disp_info(obj, inherited)

% DISP_INFO disp_info field for P_BOOST

% @p_boost/disp_info.m
% Jeremy Barnes, 27/9/1999
% $Id$

if (nargin == 2)
   disp_info(obj.boost, 'inherited');
   disp(['    --- inherited from p_boost:']);
end

disp(['      p             = ' int2str(get_p(obj))]);
