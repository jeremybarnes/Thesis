function e = training_error(obj)

% TRAINING_ERROR return the training error of a NEURAL_NET
%
% SYNTAX:
%
% e = training_error(obj)
%
% RETURNS:
%
% The training error is the number of training samples that are
% classified incorrectly.  This is returned in E.

% @neural_net/training_error.m
% Jeremy Barnes 3/10/1999
% $Id$

[x_data, y_data] = training_data(obj);

e = empirical_risk(obj, x_data, y_data);
