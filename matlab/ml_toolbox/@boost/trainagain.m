function [obj_r, context] = trainagain(obj)

% TRAINAGAIN perform another training iteration of the boosting algorithm
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
% [obj_r, wl_y] = trainagain(obj)
% This form also returns the results of the weaklearner's classification
% of the training samples in wl_y.
%
% RETURNS:
%
% A classifier that has had one more iteration of "boosting" performed on it

% @boost/trainagain.m
% Jeremy Barnes, 25/4/1999
% $Id$

if (aborted(obj))
   obj_r = obj;
   warning('trainagain: attempt to train when training aborted');
   return;
end

% create and train a new classifier

x_data = x(obj);
y_data = y(obj);
w_data = w(obj);

new_c = train(weaklearner(obj), x_data, y_data, w_data);

% find the training error
new_error = training_error(new_c);

% see what this algorithm does to our data
new_y = classify(new_c, x_data);

% find if we need to abort
if ((new_error == 0) | (new_error > 0.5 - eps))
   obj_r = abort(obj);
   return
end


% Update classifier weights
bt = - 0.5 * log(new_error / (1 - new_error));

% Update sample weights
new_w = w_data .* exp(-bt .* ((new_y == y_data)*2-1));
new_w = new_w ./ sum(new_w);

% Change the object
obj = add_iteration(obj, new_c, [obj.b bt], new_w);

obj_r = obj;

context.wl_y = new_y;
context.wl_instance = new_c;
context.bt = bt;
