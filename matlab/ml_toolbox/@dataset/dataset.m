function obj = dataset(categories, dimensions)

% DATASET - dataset to be used in classification problem
%
% This is the constructor for the dataset class.
%
% SYNTAX:
%
% d = dataset(categories, dimensions)
%
% Generates an empty dataset, with the specified CATEGORIES, and the
% specified number of DIMENSIONS.
%
% RETURNS:
%
% A DATASET object in D, initialised as required.

% @dataset/dataset.m
% Jeremy Barnes, 2/4/1999
% $Id$

if (dimensions < 1)
   error('dataset: Data must be at least one dimensional');
end

if (~(isa(categories, 'category_list')))
   error('dataset: Categories must be a CATEGORY_LIST object');
end

% Set up our variables

obj.initialised = 1;

obj.dimensions = dimensions;

obj.categories = categories;

obj.x_values = zeros(0, dimensions);
obj.y_values = zeros(0, 1);
obj.numsamples = 0;

obj = class(obj, 'dataset');

superiorto('double');
