function e = training_error(obj)

% TRAINING_ERROR return the training error of a BOOST object
%
% SYNTAX:
%
% e = training_error(obj)
%
% RETURNS:
%
% The training error is the sum of the weights of samples that are
% classified incorrectly.  This is returned in E.

% @boost/training_error.m
% Jeremy Barnes 22/4/1999
% $Id$

x_data = x(obj);
y_data = y(obj);

e = empirical_risk(obj, x_data, y_data);
