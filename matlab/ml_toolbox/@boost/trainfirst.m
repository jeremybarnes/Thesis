function obj_r = trainfirst(obj, varargin)

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
% RETURNS:
%
% A classifier that has had one iteration of "boosting" performed on it

% @boost/trainfirst.m
% Jeremy Barnes, 25/4/1999
% $Id$

[obj.x, obj.y, w] = get_xyw(obj, 'trainonce', varargin);

% Normalise our w vector
obj.w = w ./ sum(w);

obj = trainagain(obj);

obj_r = obj;



