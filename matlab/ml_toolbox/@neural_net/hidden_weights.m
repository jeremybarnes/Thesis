function w_h = hidden_weights(obj)

% HIDDEN_WEIGHTS return the weights of the hidden unit for a neural net
%
% SYNTAX:
%
% w_h = hidden_weights(obj)
%
% RETURNS:
%
% A (input_units+1 -by- hidden_units) matrix with the weights of the
% hidden units.  The first row corresponds to the (implicit) bias input
% which is always x=1.

% @neural_net/hidden_weights.m
% Jeremy Barnes, 4/10/1999
% $Id$

w_h = obj.w_hidden;

