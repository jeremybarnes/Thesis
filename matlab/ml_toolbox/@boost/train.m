function obj_r = train(obj, x, y, w)

% TRAIN - supervised training of a classifier
%
% SYNTAX:
%
% obj_r = train(obj, x, y)
% obj_r = train(obj, dataset, w)
%
% Performs supervised training on the classifier using either the dataset
% {x, y} or the dataset DATASET.
%
% RETURNS:
%
% A classifier that has been trained by the given data.

% @classifier/train.m
% Jeremy Barnes, 4/4/1999
% $Id$

% PRECONDITIONS
% none

warning('train: abstract method called');


obj_r = obj;


% POSTCONDITIONS
check_invariants(obj);

return;

