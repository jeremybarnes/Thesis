function obj = boost(weaklearner)

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
% WEAKLEARNER is a any descendent type of the CLASSIFIER class (using
% another BOOST as the weaklearner is not recommended for sanity!).  It
% is used as a template to construct useful instances of a weak learner.
%
% RETURNS:
%
% OBJ is the new boost object.
%

% @boost/boost.m
% Jeremy Barnes, 22/4/1999
% $Id$

parent = classifier(categories(weaklearner), dimensions(weaklearner));
obj = struct(parent);


% This is a template, which is trained at each boosting iteration
obj.weaklearner = weaklearner;

% boosting parameters
obj.iterations = 0;

% Classifiers are stored as an array of objects.  The untrained
% weaklearner is initially put into the first one as a placeholder
% (overwritten on the first training iteration).
obj.classifiers = weaklearner;

% These are the sample weights to use for the NEXT iteration
obj.w = [];

% Once we try to train, these will contain the data to be used in training
obj.x = [];
obj.y = [];

% If the training error is zero for a particular classifier, or if it is
% unlikely that it will ever approach zero, then we can abort the
% training.  This condition is handled by this flag.
obj.aborted = 0;

% The classifier weights
obj.b = zeros(1, 0);

% construct class and define superior/inferior relationship
obj = class(obj, 'boost', parent);
superiorto('double', 'classifier');
