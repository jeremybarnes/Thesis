function obj_r = trainagain(obj)

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

% PRECONDITIONS
% none

if (obj.iterations > obj.maxiterations)
   obj_r = obj;
   warning('trainagain: training past MAXITERATIONS');
end

if (obj.aborted)
   obj_r = obj;
   warning('trainagain: attempt to train when training is aborted');
   return;
end


% create and train a new classifier

new_c = train(obj.weaklearner, obj.x, obj.y, obj.w);

% find the training error
new_error = training_error(new_c);

% see what this algorithm does to our data
new_y = classify(new_c, obj.x);

% find if we need to abort
if ((new_error == 0) | (new_error > 0.49))
   obj.maxiterations = obj.iterations;
   obj.aborted = 1;
   obj_r = obj;
   return;
end


% This section updates the weights.

phi = 0.5; % phi is here in case we want to use "soft margins".

% beta_t is one if new_error is 0.5, and drops down towards zero as
% new_error approaches zero.
beta_t =(new_error * (1 - phi)) / (phi * (1 - new_error));

% bt is zero if new_error is 0.5, and drops down towards minus infinity
% as new_error approaches zero.
bt = log(beta_t);


new_w = obj.w .* exp(bt .* (new_y == obj.y));
sum_new_w = sum(new_w);

if (sum(new_w) == Inf)
   obj.maxiterations = obj.iterations;
   obj.aborted = 1;
   obj_r = obj;
   disp('Aborted due to infinite weight vector');
   return;
end

new_w = new_w ./ sum_new_w;

% This is where we use our p parameter.  This has the effect of rewarding
% the classifiers that do well more and more as p increases.
bt = sign(bt) * abs(bt)^(1/obj.p);

% create a structure for our new classifier
s.w = obj.w;
s.classifier = new_c;
s.error = new_error;

% Update everything for our next cycle
obj.classifiers{obj.iterations+1} = s;
obj.b(obj.iterations+1) = bt;
obj.w = new_w;
obj.iterations = obj.iterations + 1;

obj_r = obj;

% POSTCONDITIONS
check_invariants(obj_r);

return;




