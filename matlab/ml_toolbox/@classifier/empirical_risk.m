function Pe = empirical_risk(obj, x, y)

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

% PRECONDITIONS
% none


this_y = classify(obj, y);
errors = (this_y ~= y);

Pe = sum(errors) ./ length(y);


% POSTCONDITIONS
check_invariants(obj);

return;

