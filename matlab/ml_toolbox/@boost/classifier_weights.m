function b = classifier_weights(obj)

% CLASSIFIER_WEIGHTS return classifier weights of boosting algorithm
%
% SYNTAX:
%
% b = classifier_weights(obj)
%
% RETURNS:
%
% B is a column vector containing the weights of the instances of the
% weaklearner of the boosting algorithm OBJ.

% @boost/classifier_weights.m
% Jeremy Barnes, 6/8/1999
% $Id$

b = obj.b;

