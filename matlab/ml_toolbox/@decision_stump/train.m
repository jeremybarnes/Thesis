function obj_r = train(obj, varargin)

% TRAIN supervised batch training of a decision stump
%
% SYNTAX:
%
% obj_r = train(obj, x, y, w)
% obj_r = train(obj, dataset, w)
%
% Performs supervised training on the classifier using either the dataset
% {X, Y} or the dataset DATASET.  The relative importance (weight) of
% each training sample is specified in the W parameter (if omitted, this
% parameter defaults to all samples weighted evenly).
%
% RETURNS:
%
% OBJ_R is a classifier that has been trained by the given data.

% @decision_stump/train.m
% Jeremy Barnes, 23/4/1999
% $Id$


% PRECONDITIONS
[x, y, w] = get_xyw(obj, 'train', varargin);


% This section calculates the optimal variable, and value of that
% variable, about which to make the split.
%
% By "optimal", the split which minimises the value of the
% 'misclassification' cost function is meant.
%
% Candidate split points for each variable are all distinct values of
% that variable.  These are searched in a exhaustive fashion for the
% optimal value.

cat = numcategories(obj.categories);
s = size(x);
dimensions = s(2);

[var, val, leftcat, rightcat] = train_guts(x, y, w, dimensions, ...
						  cat);

% We now know which variable to split on
obj.splitvar = var;
obj.splitval = val;

obj.leftcategory = leftcat;
obj.rightcategory = rightcat;

% Calculate the training error
trainy = classify(obj, x);
trainerrs = (trainy ~= y);
train_err = trainerrs' * w;

obj.trainingerror = train_err;


obj_r = obj;

% POSTCONDITIONS
check_invariants(obj_r);




function [var, val, left_cat, right_cat] = train_guts(x, y, w, ...
						  dimensions, cat);


% TRAIN_GUTS the "guts" of the train procedure, separated from all the
% object oriented stuff.  This is designed to be replaced by higher
% efficiency C code.

var = 0; val = 0.0;

best_Q = Inf; % anything can beat this impurity!

for i=1:dimensions

   % Find candidate split points.  Remove the highest one, as otherwise
   % the set of points > than this value will be empty, which is both
   % pointless and annoying to program for.

   candidate_points = [x(:, i) y w];

   % Sort them...
   candidate_points = sortrows(candidate_points, [1]);
   candidate_x = candidate_points(:, 1);
   candidate_y = candidate_points(:, 2);
   candidate_w = candidate_points(:, 3);

   w_sum = sum(candidate_w);

   % Initialise our data
   left_total = zeros(1, cat);
   left_sum = 0.0;

   right_total = category_weight(candidate_y, candidate_w, cat);
   right_sum = w_sum;

   for j=1:length(candidate_points-1) % leave out last point...

      % Extract the value we are swapping over
      this_x = candidate_x(j);
      this_y = candidate_y(j);
      this_w = candidate_w(j);

      % Swap it
      left_total(this_y + 1) = left_total(this_y + 1) + this_w;
      left_sum = left_sum + this_w;

      right_total(this_y + 1) = right_total(this_y + 1) - this_w;
      right_sum = right_sum - this_w;

      % Normalise to a density
      if (left_sum > eps)
	 left_dens = left_total ./ left_sum;
      else
	 left_dens = 0.0;
      end

      if (right_sum > eps)
	 right_dens = right_total ./ right_sum;
      else
	 right_dens = 0.0;
      end

      % Calculate our left and right Q functions
      Qleft  = misclassification(left_dens);
      Qright = misclassification(right_dens);

      % Calculate our new impurity
      this_Q = (Qleft .* left_sum + Qright .* right_sum) ./ ...
	       w_sum; % 5% of time on this line

      % If our new impurity is better, then we can be happy and joyous,
      % and record this fact for the calling routine.
      % Also, save the y and w vectors so that we can later calcualte
      % the categories.
      if (this_Q < best_Q + eps)
	 var = i; val = this_x; best_Q = this_Q;
	 [max_dens, max_index] = max(left_dens);
	 left_cat = max_index - 1;
	 [max_dens, max_index] = max(right_dens);
	 right_cat = max_index - 1;
      end
   end
end









function Q = misclassification(dens)

% MISCLASSIFICATION calculate misclassification loss function
%
% This function calculates the misclassification loss function, given an
% array of probability densities.
%
% The probability densities are a vector of length m, where m is the
% number of categories in the training data.
%
% Each value dens is defined as follows:
%
% dens(i) = proportion of samples within this domain with class i.
%
% Thus, the densities should sum to 1.
%
% The actual function calculation is very simple.

Q = 1 - max(dens);










function cats = category_weight(y, w, cat)

% CATEGORY_WEIGHT amount of weight in each category
%
% Y and W contain {category, weight} pairs.  There are a total of CAT
% categories.  This routine returns a CAT-element vector which contains
% the total number of weight in each category.

cats = zeros(1, cat);

for i=0:cat-1
   cats(i+1) = sum((y == i) .* w); % 30% of time on this line
end

