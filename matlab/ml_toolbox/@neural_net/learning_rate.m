function eta = learning_rate(obj, value)

% LEARNING_RATE get/set the learning rate of a neural net
%
% eta = learning_rate(obj)        -- get the learning rate
% obj = learning_rate(obj, value) -- set the learning rate
%
% FIXME: comment

% @neural_net/learning_rate.m
% Jeremy Barnes, 2/10/1999
% $Id$

if (nargin == 1)
   % Get eta
   eta = obj.eta;
else
   % Set eta
   obj.eta = value;
   eta = obj;
end
