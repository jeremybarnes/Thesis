function obj_r = train(obj, varargin)

% TRAIN supervised batch training of a decision stump
%
% SYNTAX:
%
% obj_r = train(obj, x, y, w)
% obj_r = train(obj, dataset, w)
%
% Performs supervised training on the classifier using either the dataset
% {X, Y} or the dataset DATASET.  The relative importance (weight) of
% each training sample is specified in the W parameter (if omitted, this
% parameter defaults to all samples weighted evenly).
%
% RETURNS:
%
% OBJ_R is a classifier that has been trained by the given data.

% @decision_stump/train.m
% Jeremy Barnes, 23/4/1999
% $Id$


% PRECONDITIONS
[x, y, w] = get_xyw(obj, 'train', varargin);


% This section calculates the optimal variable, and value of that
% variable, about which to make the split.
%
% By "optimal", the split which minimises the value of the
% 'misclassification' cost function is meant.
%
% Candidate split points for each variable are all distinct values of
% that variable.  These are searched in a exhaustive fashion for the
% optimal value.

cat = numcategories(obj.categories);
s = size(x);
dimensions = s(2);

[var, val, leftcat, rightcat] = train_guts(obj, x, y, w, dimensions, ...
						  cat);

% Check for a stupid classifier
if (leftcat == rightcat)
   warning('train: useless decision stump returned');
end

% We now know which variable to split on
obj.splitvar = var;
obj.splitval = val;

obj.leftcategory = leftcat;
obj.rightcategory = rightcat;

% Calculate the training error
trainy = classify(obj, x);
trainerrs = (trainy ~= y);
train_err = trainerrs' * w;

obj.trainingerror = train_err;


obj_r = obj;

% POSTCONDITIONS
check_invariants(obj_r);
