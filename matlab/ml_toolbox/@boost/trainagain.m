function obj_r = trainagain(obj)

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
% RETURNS:
%
% A classifier that has had one more iteration of "boosting" performed on it

% @boost/trainagain.m
% Jeremy Barnes, 25/4/1999
% $Id$

% PRECONDITIONS
% none

if (obj.iterations > obj.maxiterations)
   obj_r = obj;
   warning('trainagain: attempt to train past MAXITERATIONS');
   return;
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
if ((new_error == 0) | (new_error > 0.5 - eps))
   obj.maxiterations = obj.iterations;
   obj.aborted = 1;
   obj_r = obj;
   return;
end


% This section updates the weights.  This is done...
% FIXME: comment

phi = 0.5;
bt = log((new_error * (1 - phi)) / (phi * (1 - new_error)));


new_w = obj.w .* exp(bt .* (new_y == obj.y));
new_w = new_w ./ sum(new_w);

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




