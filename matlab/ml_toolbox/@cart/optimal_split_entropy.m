function [var, val, no_optimal] = ...
    optimal_split_entropy(obj, x, y, w, cost_fn, cat)

% OPTIMAL_SPLIT calculate variable and value to split on
%
% This function calculates the optimal variable, and value of that
% variable, about which to split the tree.
%
% By "optimal", the split which minimises the value of some cost function
% is meant.  The cost function must be one of 'misclassification',
% 'entropy', or 'gini'.  These are calculated in the like-named functions
% below.
%
% Candidate split points for each variable are all distinct values of
% that variable.  These are searched in a exhaustive fashion for the
% optimal value.
%
% If none of the split points improve on the cost function, then the
% NO_OPTIMAL variable is set true.  The tree will usually be terminated
% at this node.
%
% CAT is again, of course, the number of categories.

% @cart/optimal_split_entropy.m
% Jeremy Barnes, 17/5/1999
% $Id$

s = size(x);
dimensions = s(2);

var = 0; val = 0.0; no_optimal = 1;

% In order to calculate an increase/decrease in Q, we need to be know its
% value before we made any split.  This is calculated here.

y_dens = category_weight(y, w, cat) ./ sum(w);
eval(['best_Q = ' cost_fn '(y_dens);']);

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
      eval(['Qleft = '  cost_fn '(left_dens);']);
      eval(['Qright = ' cost_fn '(right_dens);']);

      % Calculate our new impurity
      this_Q = (Qleft .* left_sum + Qright .* right_sum) ./ ...
	       w_sum;

      % If our new impurity is better, then we can be happy and joyous,
      % and record this fact for the calling routine.
      if (this_Q < best_Q + eps)
	 var = i; val = this_x; best_Q = this_Q; no_optimal = 0;
      end
   end
end

% Finished!





function Q = entropy(prob)

% ENTROPY loss function
%
% This function calculates the entropy loss function, given an
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

Q = - sum(prob .* log(prob));






function cats = category_weight(y, w, cat)

% CATEGORY_WEIGHT amount of weight in each category
%
% Y and W contain {category, weight} pairs.  There are a total of CAT
% categories.  This routine returns a CAT-element vector which contains
% the total number of weight in each category.

cats = zeros(1, cat);

for i=0:cat-1
   cats(i+1) = sum((y == i) .* w);
end



