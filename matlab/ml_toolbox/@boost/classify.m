function y = classify(obj, x)

% CLASSIFY use a classifier to classify a set of data
%
% SYNTAX:
%
% y = classify(obj, x)
%
% Classifies the data in x using the classifier obj.  Returns the class
% labels in y.
%
% RETURNS:
%
% The class labels in y.

% @boost/classify.m
% Jeremy Barnes, 25/4/1999
% $Id$

% This is a rather complicated function.
%
% The data is classified by each of the weak learners.  For each sample,
% a vote is then taken.  The "vote" is weighted by the b value for the
% classifier.
%
% This may take a long time.


% PRECONDITIONS
% none

% Initialise our votes matrix.  Cumulative totals for each category are
% across each row; the datapoints are down each column.
xs = size(x);
votes = zeros(xs(1), numcategories(obj.categories));
y = zeros(xs(1), 1);

% Normalise our voting weights.  This is particularly important, as these
% may be negative, which would result in an incorrect classification.

b = obj.b ./ sum(obj.b);

% Go through each classifier, finding out how it classified the data and
% adding its votes up for each datapoint.

for i = 1:obj.iterations
   this_struct = obj.classifiers{i};
   this_classifier = this_struct.classifier;
   this_y = classify(this_classifier, x) + 1; % +1 converts cat to col

   for j=1:xs(1)
      votes(j, this_y(j)) = votes(j, this_y(j)) + b(i);
   end
end

% Now, select the best vote from each row as our result
m = max(votes')';
for i=1:xs(1)
   max_index = find(votes(i, :) == m(i));
   if (length(max_index) > 1)
      max_index = max_index(1);
   end

   y(i) = max_index - 1; % -1 because categories go from 0 to n-1
end

% POSTCONDITIONS
check_invariants(obj);

return;

