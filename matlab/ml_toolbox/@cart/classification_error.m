function e = classification_error(obj, varargin)

% CLASSIFICATION_ERROR return the classification error of a CART object
%
% SYNTAX:
%
% e = classification_error(obj, x, y, [w])
% e = classification_error(obj, dataset, [w])
%
% RETURNS:
%
% The training error is the sum of the weights of samples that are
% classified incorrectly.  This is returned in E.  The {X, Y} parameter
% can either be specified as a DATASET class or via individual variables.
%
% The W vector contains the weight (relative importance) of each data
% point.  If not specified, it defaults to all ones.  This has the result
% of E being the number of points that are classified incorrectly.

% @cart/classification_error.m
% Jeremy Barnes 22/4/1999
% $Id$

% PRECONDITIONS
[x, y, w] = get_xyw(obj, 'classification_error', varargin);

% Classify the data
yc = classify(obj, x);

% Find which ones are wrong
ywrong = (yc != y);

% Find the total weight of wrong answers
weightwrong = sum(ywrong .* w);

% Find the proportion of wrong weight
e = weightwrong / sum(w);

% POSTCONDITIONS:
check_invariants(obj);
