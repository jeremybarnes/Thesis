function alpha = momentum(obj, value)

% MOMENTUM get/set the momentum of a neural net
%
% alpha = momentum(obj)      -- get the momentum
% obj = momentum(obj, value) -- set the momentum
%
% FIXME: comment

% @neural_net/momentum.m
% Jeremy Barnes, 2/10/1999
% $Id$

if (nargin == 1)
   % Get eta
   alpha = obj.alpha;
else
   % Set eta
   obj.alpha = value;
   alpha = obj;
end
