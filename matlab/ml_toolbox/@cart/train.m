function obj_r = train(obj, varargin)

% TRAIN supervised training of CART classifier
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

% @cart/train.m
% Jeremy Barnes, 5/4/1999
% $Id$

obj = cart(obj);

[x, y, w] = get_xyw(obj, 'train', varargin);

% Find the domain of the independent variable.
x_max = max(x); % Returns a row vector with the max of each column
x_min = min(x);

x_range = [x_max; x_min];

% Training is best done as a recursive procedure.  As this method is
% inefficient to call recursively, recursively call the one below.
obj.tree = recursive_train(obj, x, y, w, x_range, 1, obj.maxdepth, ...
			   obj.cost_fn, numcategories(obj.categories));

% The second part of training is pruning.  Again, this is done
% recursively.
obj.tree = recursive_prune(obj, obj.tree, x, y, w);

% And there we have it!

obj_r = obj;
