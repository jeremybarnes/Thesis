function Pe = empirical_risk(obj, varargin)

% EMPIRICAL_RISK calculate the empirical risk of a data set
%
% SYNTAX:
%
% Pe = empirical_risk(obj, x, y)
% Pe = empirical_risk(obj, dataset)
%
% Calculates the empirical risk of a test dataset given either the
% dataset {x, y} or the dataset DATASET.
%
% RETURNS:
%
% The empirical risk of the given dataset.  This is simply the proportion
% of training samples that the classifier got wrong.

% @classifier/empirical_risk.m
% Jeremy Barnes, 4/4/1999
% $Id$

[x, y] = get_xy(obj, 'empirical_risk', varargin);

this_y = classify(obj, x);

errors = (this_y ~= y);

Pe = sum(errors) ./ length(y);
