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
% d = dataset('filename')
%
% Generates a dataset from a MAT file.  The global variable DATASET_PATH
% is prepended to filename if that file is not found.  The mat file must
% have four variables: X, Y, DIMENSIONS and NUMCATEGORIES.
% 
% RETURNS:
%
% A DATASET object in D, initialised as required.

% @dataset/dataset.m
% Jeremy Barnes, 2/4/1999
% $Id$

% One dataset argument: make a copy
if ((nargin == 1) & (isa(numcategories, 'dataset')))
   obj = numcategories;
   return;
end

filename = [];
if ((nargin == 1) & (isa(numcategories, 'char')))
   % Load a file -- use dummy values for now to stop complaints
   filename = numcategories;
   numcategories = 2;
   dimensions = 2;
elseif (nargin == 0)
   numcategories = 2;
   dimensions = 2;
elseif (nargin == 1)
   dimensions = 2;
end

if (dimensions < 1)
   error('dataset: Data must be at least one dimensional!');
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

% Populate with data
if (~isempty(filename))
   obj = load(obj, filename);
end
