function obj = classifier(categories, dimensions)

% CLASSIFIER abstract ancestor class for a classification machine
%
% This is the constructor for the classifier type.
%
% SYNTAX:
%
% obj = classifier(categories, dimensions)
%
% Creates a classifier.
%
% DIMENSIONS specifies the number of dimensions that the independent
% variable will have.
%
% CATEGORIES is a CATEGORY_LIST object that specifies the categories to be
% used in the data.
%
% RETURNS:
%
% OBJ is the new classifier.

% @classifier/classifier.m
% Jeremy Barnes, 4/4/1999
% $Id$

% 0 arguments -- make a default version
if (nargin == 0)
   categories = category_list;
   dimensions = 2;
end

% 1 argument -- just make a copy
if ((nargin == 1) & (isa(categories, 'classifier')))
   obj = categories;
   return
end

% More than one argument -- create a new one
if (dimensions <= 0)
   error('classifier: DIMENSIONS must be >= 1');
end

if (~isa(categories, 'category_list'))
   error('classifier: CLASSES needs to be a CATEGORY_LIST');
end


% initialisation of variables in obj
obj.initialised = 1;
obj.dimensions = dimensions;
obj.categories = categories;
obj.trained_samples = 0;

% construct class and define superior/inferior relationship
obj = class(obj, 'classifier');
superiorto('double');
