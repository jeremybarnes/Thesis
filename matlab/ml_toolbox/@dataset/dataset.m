function obj = dataset(numcategories, dimensions)

% DATASET - dataset to be used in classification problem
%
% This is the constructor for the dataset class.
%
% SYNTAX:
%
% d = dataset(numcategories, dimensions)
%
% Generates an empty dataset, with the specified NUMCATEGORIES, and the
% specified number of DIMENSIONS.
%
% RETURNS:
%
% A DATASET object in D, initialised as required.

% @dataset/dataset.m
% Jeremy Barnes, 2/4/1999
% $Id$

% One dataset argument: make a copy
if ((nargin == 1) & (isa(categories, 'dataset')))
   obj = categories;
   return;
end

% Default values
if (nargin == 0)
   numcategories = 2;
   dimensions = 2;
elseif (nargin == 1)
   dimensions = 2;
end

if (dimensions < 1)
   error('dataset: Data must be at least one dimensional');
end

% Set up our variables
obj.initialised = 1;
obj.dimensions = dimensions;
obj.numcategories = numcategories;

obj.x_values = zeros(0, dimensions);
obj.y_values = zeros(0, 1);
obj.numsamples = 0;

obj = class(obj, 'dataset');
superiorto('double');
