% dataset.m
% Jeremy Barnes, 2/4/1999
%
% DATASET - dataset to be used in classification problem
%
% This is the constructor for the dataset class.
%
% SYNTAX:
%
% d = dataset(labels, dimensions)
%    - generates an empty dataset, with the specified class labels, and
%      the specified number of dimensions. 
%
% RETURNS:
%
% A dataset object in D, initialised as required.

function d = dataset(labels, dimensions)

% PRECONDITIONS
if (dimensions < 1)
   error('dataset: Data must be at least one dimensional');
end

if (~(isa(labels, 'classlabel')))
   error('dataset: Class labels must be a CLASSLABEL object');
end

% Set up our variables

d.initialised = 1;

d.dimensions = dimensions;

d.labels = labels;

d.samples = zeros(0, dimensions);
d.numsamples = 0;

d = class(d, 'dataset');

% POSTCONDITIONS
global_postconditions(d);

return;