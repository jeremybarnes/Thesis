function disp_info(obj, inherited)

% DISP_INFO method for BOOST object

% @boost/disp_info.m
% Jeremy Barnes, 19/8/1999
% $Id$

if (nargin == 2)
   disp_info(obj.classifier, 'inherited');
   disp(['    --- inherited from boost:']);
end

disp(['      iterations    = ' int2str(iterations(obj))]);

