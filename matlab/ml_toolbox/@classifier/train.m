function obj_r = train(obj, x, y, w)

% TRAIN - supervised training of a classifier
%
% SYNTAX:
%
% obj_r = train(obj, x, y, w)
% obj_r = train(obj, dataset, w)
%
% Performs supervised training on the classifier using either the dataset
% {x, y} or the dataset DATASET.  If specified, the weight vector W is
% used to determine the relative importance of each training sample in
% the dataset.
%
% RETURNS:
%
% A classifier that has been trained by the given data.

% @classifier/train.m
% Jeremy Barnes, 4/4/1999
% $Id$

warning('train: abstract method called');


obj_r = obj;
