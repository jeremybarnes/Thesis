function obj_r = train(obj, varargin)

% TRAIN supervised training of a classifier
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

% @boost/train.m
% Jeremy Barnes, 4/4/1999
% $Id$

% This is implemented simply by calling TRAINFIRST, and then repeatedly
% calling TRAINAGAIN until the training is aborted or maxiterations are
% reached.

[x, y, w] = get_xyw(obj, 'train', varargin);


% Initialise our training...

obj = trainfirst(obj, x, y, w);


% And now train until we are finished.

while ((~obj.aborted) & (obj.iterations < obj.maxiterations))
   obj = trainagain(obj);
end


obj_r = obj;
