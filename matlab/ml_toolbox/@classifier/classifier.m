function obj = classifier(numcategories, dimensions)

% CLASSIFIER abstract ancestor class for a classification machine
%
% This is the constructor for the classifier type.
%
% SYNTAX:
%
% obj = classifier(numcategories, dimensions)
%
% Creates a classifier.
%
% DIMENSIONS specifies the number of dimensions that the independent
% variable will have.
%
% CATEGORIES is a number that specifies the number of labels in the
% output space.
%
% RETURNS:
%
% OBJ is the new classifier.

% @classifier/classifier.m
% Jeremy Barnes, 4/4/1999
% $Id$

% 0 arguments -- make a default version
if (nargin == 0)
   numcategories = 2;
   dimensions = 2;
end

% 1 argument -- just make a copy
if ((nargin == 1) & (isa(numcategories, 'classifier')))
   obj = numcategories;
   return
end

% More than one argument -- create a new one
if (dimensions <= 0)
   error('classifier: DIMENSIONS must be >= 1');
end

% initialisation of variables in obj
obj.initialised = 1;
obj.dimensions = dimensions;
obj.numcategories = numcategories;
obj.trained_samples = 0;

% construct class and define superior/inferior relationship
obj = class(obj, 'classifier');
superiorto('double');
