function [obj_r, context] = trainfirst(obj, varargin)

% TRAINFIRST perform first training iteration of a neural net
%
% SYNTAX:
%
% obj_r = trainfirst(obj, x, y)
% obj_r = trainfirst(obj, dataset)
%
% Performs supervised training on the classifier using either the dataset
% {X, Y} or the dataset DATASET.
%
% [obj_r, context] = trainfirst(...)
%
% This form, intended primarily for internal use, returns information for
% the test function in the context variable.
%
% RETURNS:
%
% OBJ_R is a neural net that has been trained for one more iteration.

% @neural_net/trainfirst.m
% Jeremy Barnes, 2/10/1999
% $Id$

% Pretty much all the work is done by the trainfirst method... we just
% give it the data first.

[obj.x, obj.y] = get_xy(obj, 'trainonce', varargin);

[obj, context] = trainagain(obj);

obj_r = obj;



