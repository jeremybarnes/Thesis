function disp_info(obj, inherited)

% DISP_INFO method for BOOST object

% @boost/disp_info.m
% Jeremy Barnes, 19/8/1999
% $Id$

if (nargin == 2)
   disp_info(obj.classifier, 'inherited');
   disp(['    --- inherited from neural_net:']);
end

disp(['      hidden_units  = ' int2str(hidden_units(obj))]);
disp(['      iterations    = ' int2str(iterations(obj))]);

