function [obj_r, context] = trainfirst(obj, varargin)

% TRAINFIRST perform first training iteration of the boosting algorithm
%
% SYNTAX:
%
% obj_r = trainfirst(obj, x, y, [w])
% obj_r = trainfirst(obj, dataset, [w])
%
% Performs supervised training on the classifier using either the dataset
% {X, Y} or the dataset DATASET.  If specified, the weight vector W is
% used to determine the initial relative importance of each training
% sample in the dataset.
%
% [obj_r, wl_y] = trainfirst(...)
%
% This form, intended primarily for internal use, returns the
% weaklearner's classification of the training samples in the wl_y
% variable.
%
% RETURNS:
%
% A classifier that has had one iteration of "boosting" performed on it

% @boost/trainfirst.m
% Jeremy Barnes, 25/4/1999
% $Id$

[obj.x, obj.y, w] = get_xyw(obj, 'trainonce', varargin);

% Normalise our w vector
obj.w = w ./ sum(w);

[obj, context] = trainagain(obj);

obj_r = obj;



