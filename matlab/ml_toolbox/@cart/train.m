function obj_r = train(obj, x, y)

% TRAIN supervised training of CART classifier
%
% SYNTAX:
%
% obj_r = train(obj, x, y)
% obj_r = train(obj, dataset)
%
% Performs supervised training on the classifier using either the dataset
% {x, y} or the dataset DATASET.
%
% RETURNS:
%
% OBJ_R is a classifier that has been trained by the given data.
%

% @cart/train.m
% Jeremy Barnes, 5/4/1999
% $Id$


% PRECONDITIONS
% none

% Find the domain of the independent variable.

x_max = max(x); % Returns a row vector with the max of each column
x_min = min(x);

x_range = [x_max; x_min];

% Training is best done as a recursive procedure.  As this method is
% inefficient to call recursively, recursively call the one below.

obj.tree = recursive_train(x, y, x_range, 1, maxdepth);

% The second part of training is pruning.  Again, this is done
% recursively.

obj.tree = recursive_prune(obj.tree, x, y);

% And there we have it!


% POSTCONDITIONS
check_invariants(obj);






function tree = recursive_train(x, y, domain, depth, maxdepth, cost_fn)

% RECURSIVE_TRAIN generate a tree to recursively train our classifier.
%
% Trees are implemented as structures.  The structure has the following
% attributes:
%
% tree.left  - another tree object, or 'null' if this is a terminal node.
% tree.right - ditto
% tree.splitvar - variable to split on
% tree.splitval - value of variable to split on.  Left is <=, Right is >.
%
% This is a nonterminal node.
%
% Alternatively:
%
% tree = category (where category is a number from 0 to numcategories-1)
%
% This is a terminal node.
%
% The DOMAIN input specifies the domain over which the data in X
% ranges.  It is organised as a 2xm matrix, where m is the number of
% dimensions.  The first row specifies the maximum value of that
% dimension; the second row specifies the minimum.
%
% X and Y are the training data that falls within RANGE.  Note that this
% will usually be a subset of the training data (only the part within our
% domain).  X is the value of the independent variable; Y are the
% corresponding category numbers.
%
% DEPTH specifies the current recursion depth.  If this number is greater
% than MAXDEPTH, then the function automatically returns 'null'.
%
% The node will also be marked terminal if all of the data belongs to one
% class.

% Check for the end of recursion.  In this case, simply choose the
% category with the greatest number of samples in y.
if (depth > maxdepth)
   cats = category_count(y);

   max_count = max(cats);
   max_index = find(cats == max_count);
   if (length(max_index) > 1)
      category = max_index(1);
   else
      category = max_index;
   end

   % Terminal node
   tree = category;
   return;
end

% We also end our recursion if all of our data samples belong to one
% category.
e = (y = y(1));
if (sum(e) == length(y)) % if all elements of e are one (true)
   tree = y(1);
   return;
end

% Find where to split our data
[tree.splitvar, tree.splitval, no_optimal] = 
   optimal_split(x, y, cost_fn);

% If no split decreases the loss function, then recursion is finished.
% In that case, again select the most populous classifier as our terminal
% node.  NOTE that I am not sure if this code will ever be executed -- I
% have a hunch that the previous two cases will preclude this case ever
% being true.
if (no_optimal)
   cats = category_count(y);

   max_count = max(cats);
   max_index = find(cats == max_count);
   if (length(max_index) > 1)
      category = max_index(1);
   else
      category = max_index;
   end

   % Terminal node
   tree = category;
   return;
end

% Split our data about the split point
[left_x, left_y, right_x, right_y] = 
   split_data(x, y, tree.splitvar, tree.splitval);

% Recalculate our domain matrices
left_domain_max = domain(1, :);
left_domain_max(tree.splitvar) = tree.splitval;

right_domain_min = domain(2, :);
right_domain_min(tree.splitvar) = tree.splitval;

left_domain  = [left_domain_max; domain(2, :)];
right_domain = [domain(1, :); right_domain_min];

% Recursively call ourself to calculate the left and right trees
tree.left  = recursive_train(left_x,  left_y,  left_domain,
                             depth+1, maxdepth, cost_fn);

tree.right = recursive_train(right_x, right_y, right_domain,
                             depth+1, maxdepth, cost_fn);

% Finished!






function [var, val, no_optimal] = optimal_split(x, y, cost_fn)

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

s = size(x);
dimensions = s(2);

var = 0; val = 0.0; no_optimal = 1;

% In order to calculate an increase/decrease in Q, we need to be know its
% value before we made any split.  This is calculated here.

y_dens = category_count(y) ./ length(y);
eval(['best_Q = ' cost_fn '(y_dens);']);

for i=1:dimensions

   % Find candidate split points.
   candidate_points = x(:, i);

   for point=candidate_points
      
      % Split up our data
      [left_x, left_y, right_x, right_y] = split_data(x, y, i, point);

      % Calculate the probability of samples being in each
      % category.
      left_dens = category_count(left_y) ./ length(left_y);
      right_dens = category_count(right_y) ./ length(right_y);

      % Calculate our left and right Q functions
      eval(['Qleft = '  cost_fn '(left_dens);']);
      eval(['Qright = ' cost_fn '(right_dens);']);

      % Calculate our new impurity
      this_Q = (Qleft .* length(left_y) + Qright .* length(right_y)) ./ ...
	       length(y);

      % If our new impurity is better, then we can be happy and joyous.
      if (this_Q < best_q + eps)
	 var = i; val = point; best_Q = this_q; no_optimal = 0;
      end
   end
end

% Finished!







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






function Q = gini(prob)

% GINI loss function
%
% Same as misclassification, but calculates the Gini function instead.

Q = 1 - sum(prob.^2);






function Q = entropy(prob)

% ENTROPY loss function
%
% Same as misclassification, but calculates the Entropy function instead.

Q = - sum(prob .* log(prob));






function cats = category_count(y)

% CATEGORY_COUNT return the number of y elements in each category
% FIXME: comment

num_categories = max(y);
cats = zeros(1, num_categories+1);

for i=0:num_categories
   cats(i+1) = sum(y == i);
end






function [left_x, left_y, right_x, right_y] = split_data(x, y, splitvar, splitval);
% SPLIT_DATA separate a dataset by splitting value of one variable
%
% This function takes a dataset {X,Y} and splits it into two disjoint
% parts.  The two parts are split on one variable of X (the variable
% given by SPLITVAR), into "left" and "right" datasets {LEFT_X, LEFT_Y}
% and {RIGHT_X, RIGHT_Y}.  The left half satisfies X(SPLITVAR) <= SPLITVAL,
% with the right half satisfying X(SPLITVAR) > SPLITVAL.

% Separate our data into left and right halves.  To do this, create an
% index vector which shows which data points are to the left and the
% right of the split point.
left_index  = find(x(:, splitvar) <= splitval);
right_index = find(x(:, splitvar) >  splitval);

left_x  = x(left_index,  :);  left_y  = y(left_index,  :);
right_x = x(right_index, :);  right_y = y(right_index, :);






function newtree = recursive_prune(tree, x, y)
% more on this later...
% FIXME: finish

newtree = tree; % Temporary, until I get around to implementing it.
