function deriv = node_transfer_deriv(obj, node_in, node_out)

% NODE_TRANSFER_FUNCTION calculate the derivative of the sigmoid function
%
% SYNTAX:
%
% out = node_transfer_function(obj, node_in, node_out)
%
% This function calculates the derivative of the sigmoid function.  It is
% passed two sets of values: the input values to the node and the output
% values of the node (the output values are there in case they can be
% used to evaluate the function more quickly; true in the case of the
% sigmoid function at least).
%
% It operates elementwise on an input of any size.

% @neural_net/node_transfer_deriv.m
% Jeremy Barnes, 2/10/1999
% $Id$

% The formula is simple, so is this function...

deriv = node_out .* (1 - node_out);
