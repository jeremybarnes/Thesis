function obj = boost(weaklearner, maxiterations)

% BOOST classifier based upon boosting of a weaker classifier
%
% This is the constructor for the BOOST type.
%
% SYNTAX:
%
% obj = boost(weaklearner)
%
% Creates a boosted classifier, based upon the WEAKLEARNER.  The
% dimensions and categories of the weak learner are copied as the
% dimensions and categories of the boosted learner.
%
% MAXITERATIONS specifies the maximum number of times that the boosting
% algorithm can be iterated.  It is used to allocate storage ahead of
% time to improve efficiency.
%
% RETURNS:
%
% OBJ is the new boost object.
%

% @boost/boost.m
% Jeremy Barnes, 22/4/1999
% $Id$


% PRECONDITIONS
if (~isa(weaklearner, 'classifier'))
   error('boost: weak learner must be a CLASSIFIER object');
end


parent = classifier(categories(weaklearner), dimensions(weaklearner));
obj = struct(parent);


% This is a template, which is trained at each boosting iteration
obj.weaklearner = weaklearner;

% boosting parameters
obj.maxiterations = maxiterations;
obj.iterations = 0;

% Classifiers are stored as a cell array of structures.
% The fields are:
% obj.classifiers{i}.classifier = classifier class
% obj.classifiers{i}.error = classification error for this classifier
% obj.classifiers{i}.w = weights for this classifier

obj.classifiers = cell(1, maxiterations);

% These are the weights to use for the NEXT iteration
obj.w = [];

% Once we try to train, these will contain the data to be used in training
obj.x = [];
obj.y = [];

% If the training error is zero for a particular classifier, or if it is
% unlikely that it will ever approach zero, then we can abort the
% training.  This condition is handled by this flag.

obj.aborted = 0;

% The b value is a measure of how good each classifier is
obj.b = zeros(1, maxiterations);

% construct class and define superior/inferior relationship
obj = class(obj, 'boost', parent);
superiorto('double', 'classifier');


% POSTCONDITIONS
check_invariants(obj);

return;
