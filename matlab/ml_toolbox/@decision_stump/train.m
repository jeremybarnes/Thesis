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




function [var, val, leftcat, rightcat] = train_guts(x, y, w, ...
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

   candidate_points = x(:, i);
   point_to_remove = find(candidate_points == max(candidate_points));
   if length(point_to_remove) > 1
      point_to_remove = point_to_remove(1);
   end
   candidate_points(point_to_remove) = [];


   for j=1:length(candidate_points)
      point = candidate_points(j);
      
      % Split up our data
      [left_x, left_y, right_x, right_y, left_w, right_w] = ...
         split_data(x, y, w, i, point);

      % Calculate the probability of samples being in each
      % category.
      left_sum = sum(left_w);
      if (left_sum > eps)
	 left_dens = category_weight(left_y, left_w, cat) ./ left_sum;
      else
	 left_dens = 0.0;
      end

      right_sum = sum(right_w);
      if (right_sum > eps)
	 right_dens = category_weight(right_y, right_w, cat) ./ ...
	     right_sum;
      else
	 right_dens = 0.0;
      end

      % Calculate our left and right Q functions
      Qleft  = misclassification(left_dens);
      Qright = misclassification(right_dens);

      % Calculate our new impurity
      this_Q = (Qleft .* sum(left_w) + Qright .* sum(right_w)) ./ ...
	       sum(w); % 5% of time on this line

      % If our new impurity is better, then we can be happy and joyous,
      % and record this fact for the calling routine.
      % Also, save the y and w vectors so that we can later calcualte
      % the categories.
      if (this_Q < best_Q + eps)
	 var = i; val = point; best_Q = this_Q;
	 best_left_y  = left_y;   best_left_w = left_w;
	 best_right_y = right_y;  best_right_w = right_w;
      end
   end
end

% Now, in each half of the data find the category with the greatest
% weight, as this category is the one that we choose.
left_cats  = category_weight(best_left_y, best_left_w, cat);
right_cats = category_weight(best_right_y, best_right_w, cat);

left_max = max(left_cats);
right_max = max(right_cats);

left_max_cat = find(left_cats == left_max);
right_max_cat = find(right_cats == right_max);

% If there are more than one optimal categories, then just take the one
% with the lowest category number.

if (length(left_max_cat) > 1)
   left_max_cat = left_max_cat(1);
end

if (length(right_max_cat) > 1)
   right_max_cat = right_max_cat(1);
end

leftcat = left_max_cat - 1;
rightcat = right_max_cat - 1;









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









function [left_x, left_y, right_x, right_y, left_w, right_w] = ...
   split_data(x, y, w, splitvar, splitval);
% SPLIT_DATA separate a dataset by splitting value of one variable
%
% This function takes a dataset {X,Y,W} and splits it into two disjoint
% parts.  The two parts are split on one variable of X (the variable
% given by SPLITVAR), into "left" and "right" datasets {LEFT_X, LEFT_Y}
% and {RIGHT_X, RIGHT_Y}.  The left half satisfies X(SPLITVAR) <= SPLITVAL,
% with the right half satisfying X(SPLITVAR) > SPLITVAL.

% Separate our data into left and right halves.  To do this, create an
% index vector which shows which data points are to the left and the
% right of the split point.

left_index  = find(x(:, splitvar) <= splitval); % 14% of time on this line
right_index = find(x(:, splitvar) >  splitval); % 13% of time on this line

left_x  = x(left_index,  :); % 4% of time on this line
left_y  = y(left_index,  :); % 4% of time on this line
left_w  = w(left_index,  :); % 4% of time on this line

right_x = x(right_index, :); % 4% of time on this line
right_y = y(right_index, :); % 4% of time on this line
right_w = w(right_index, :); % 4% of time on this line


