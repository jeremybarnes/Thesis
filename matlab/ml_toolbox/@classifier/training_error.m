function e = training_error(obj)

% TRAINING_ERROR return the training error of a DECISION_STUMP object
%
% SYNTAX:
%
% e = training_error(obj)
%
% RETURNS:
%
% The training error is the sum of the weights of samples that are
% classified incorrectly.  This is returned in E.

% @classifier/training_error.m
% Jeremy Barnes 22/4/1999
% $Id$

[x_data, y_data] = training_data(obj);
e = empirical_risk(obj, x_data, y_data);
