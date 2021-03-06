function obj = decision_stump(categories, dimensions)

% DECISION_STUMP classifier using a one-split tree algorithm
%
% This is the constructor for the decision_stump classifier.
%
% SYNTAX:
%
% obj = decision_stump(categories, dimensions)
%
% Creates a classifier based on the "decision stump" algorithm.  This is
% a very weak learner, with the primary merit of working quite well in
% combination with the "boosting" algorithm.
%
% This classifier simply splits its data into two sections.  The split is
% parallel to one of the independent axes of the data.  The split is made
% to give the overall lowest training risk for the data.
%
% Unlike CART, no attempts are made to split the data in a manner that
% may allow further splits to operate more effectively, as no further
% splits are ever made.
%
% The CATEGORIES parameter is passed a DATASET object that represents the
% possible values (categories) of the dependent (y) variable.
%
% The DIMENSIONS parameter specifies the number of dimensions that the
% independent (x) value has.
%
% RETURNS:
%
% OBJ is the template of a decision stump.

% @decision_stump/decision_stump.m
% Jeremy Barnes, 4/4/1999
% $Id$

% One argument --> make a copy of ourself
if (nargin == 1)
   obj = categories;
   return
end

% ancestor relationship
if (nargin == 0) % zero arguments --> use default
   parent = classifier;
else
   parent = classifier(categories, dimensions);
end

% Our default split, which splits on the first variable at 0.500
obj.splitvar = 1;
obj.splitval = 0.5;
obj.leftcategory = 0;
obj.rightcategory = 1;

obj.trainingerror = 0.0;

% construct class and use superior/inferior relationship
obj = class(obj, 'decision_stump', parent);
superiorto('double', 'classifier');
