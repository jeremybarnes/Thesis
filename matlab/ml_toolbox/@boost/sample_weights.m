function w = sample_weights(obj)

% SAMPLE_WEIGHTS return sample weights of boosting algorithm
%
% SYNTAX:
%
% w = sample_weights(obj)
%
% RETURNS:
%
% W is a column vector containing the weights of the training samples of
% the boosting algorithm OBJ.

% @boost/sample_weights.m
% Jeremy Barnes, 6/8/1999
% $Id$

w = obj.w;

