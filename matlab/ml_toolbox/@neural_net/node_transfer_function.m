function out = node_transfer_function(obj, in)

% NODE_TRANSFER_FUNCTION calculate the sigmoid function
%
% SYNTAX:
%
% out = node_transfer_function(obj, in)
%
% This function calculates the Sigmoid function, which is the node
% transfer function for a "standard" neural network.  This function may
% however be redefined for a descendent type.  It operates on an input of
% any size.

% @neural_net/node_transfer_function.m
% Jeremy Barnes, 2/10/1999
% $Id$

% The formula is simple, so is this function...

out = 1 ./ (1 + exp(-in));
