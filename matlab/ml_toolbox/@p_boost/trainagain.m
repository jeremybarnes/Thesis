function [obj_r, context] = trainagain(obj)

% TRAINAGAIN perform another training iteration of the p-boosting algorithm
%
% SYNTAX:
%
% obj_r = trainagain(obj)
%
% Performs supervised training on the classifier using either the dataset
% {X, Y} or the dataset DATASET.  If specified, the weight vector W is
% used to determine the initial relative importance of each training
% sample in the dataset.
%
% RETURNS:
%
% A classifier that has had one iteration of "p-boosting" performed on it

% @p_boost/trainagain.m
% Jeremy Barnes, 25/4/1999
% $Id$

% Use the boost method to do most of the work
boost_obj = as_boost(obj);

[boost_obj, context] = trainagain(boost_obj);

p = get_p(obj);

% Update the bt value based on p
bt = context.bt;
bt = bt^(1/p);

% Add our iteration on
context.b(length(context.b)) = bt;
context.bt = bt;

% Update everything for our next cycle
obj = add_iteration(obj, context.wl_instance, context.bt, context.w);

obj_r = obj;
