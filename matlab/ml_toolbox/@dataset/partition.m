function [varargout] = partition(obj, varargin)

% PARTITION split a dataset into partitions
%
% SYNTAX:
%
% [d1, d2, ...] = partition(obj, amt1, amt2, ...)
%
% This function generates 2 or more datasets by splitting the data in OBJ
% into partitions of the size requested.  AMT1, AMT2 and so on can either
% be specified in samples (integers) or proportions (reals < 1).  The sum
% AMT1 + AMT2 + ... must total either the number of samples or 1.  The
% last AMTn value is optimal; it is calculated from the others if it is
% not specified.
%
% ... = partition(..., 'random')
%
% This form randomly reorders the data before splitting it up.

% @dataset/partition.m
% Jeremy Barnes, 3/10/1999
% $Id$

amounts = zeros(1, nargout);
random = 0;
l = length(varargin);

% Check for the random argument
if (strcmp(varargin{l}, 'random'))
   random = 1;
   l = l - 1;
end

% Go through each of our arguments, extracting the amount
for i=1:l
   amounts(i) = varargin{i};
end

% Deal with fractions
if (sum(amounts) <= 1+eps)
   amounts = amounts .* numsamples(obj);
end
   
% Calculate the last value if needed
if (l == nargout-1)
   amounts(l+1) = numsamples(obj) - sum(amounts);
end

% Randomise if wanted
if (random)
   obj = randomize(obj);
end

% Generate our partition
varargout = cell(1, nargout);
amounts = round(amounts);
upto = 1;
for i=1:length(amounts)
   this_d = dataset(numcategories(obj), dimensions(obj));
   x = obj.x_values(upto:upto+amounts(i)-1, :);
   y = obj.y_values(upto:upto+amounts(i)-1, :);
   this_d = addsamples(this_d, x, y);
   varargout{i} = this_d;
   upto = upto + amounts(i);
end

% Finish

   