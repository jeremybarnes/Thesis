function w_o = output_weights(obj)

% OUTPUT_WEIGHTS return the weights of the output unit for a neural net
%
% SYNTAX:
%
% w_h = output_weights(obj)
%
% RETURNS:
%
% A (hidden_units+1 -by- output_units) matrix with the weights of the
% output units.  The first row corresponds to the (implicit) bias input
% which is always x=1.

% @neural_net/output_weights.m
% Jeremy Barnes, 4/10/1999
% $Id$

w_o = obj.w_output;

