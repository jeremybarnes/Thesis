function obj_r = train(obj, iter, varargin)

% TRAIN supervised training of a NEURAL_NET
%
% SYNTAX:
%
% obj_r = train(obj, iter, x, y, w)
% obj_r = train(obj, iter, dataset, w)
%
% Performs supervised training on the classifier using either the dataset
% {x, y} or the dataset DATASET.  If specified, the weight vector W is
% used to determine the relative importance of each training sample in
% the dataset.
%
% RETURNS:
%
% A neural network that has been trained by the given data.

% @neural_net/train.m
% Jeremy Barnes, 2/10/1999
% $Id$

% This is implemented simply by calling TRAINFIRST, and then repeatedly
% calling TRAINAGAIN until the required number of iterations are reached.

[x, y] = get_xy(obj, 'train', varargin);

% Initialise our training...

obj = trainfirst(obj, x, y);

% And now train until we are finished.
for i=1:(iter-1)
   obj = trainagain(obj);
end

obj_r = obj;
