function obj_r = train(obj, varargin)

% TRAIN supervised training of CART classifier
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

% @cart/train.m
% Jeremy Barnes, 5/4/1999
% $Id$


% PRECONDITIONS
[x, y, w] = get_xyw(obj, 'train', varargin);

% Find the domain of the independent variable.
x_max = max(x); % Returns a row vector with the max of each column
x_min = min(x);

x_range = [x_max; x_min];

% Training is best done as a recursive procedure.  As this method is
% inefficient to call recursively, recursively call the one below.
obj.tree = recursive_train(x, y, w, x_range, 1, obj.maxdepth, obj.cost_fn, ...
			   numcategories(obj.categories));

% The second part of training is pruning.  Again, this is done
% recursively.
obj.tree = recursive_prune(obj.tree, x, y, w);

% And there we have it!

obj_r = obj;

% POSTCONDITIONS
check_invariants(obj_r);






function tree = recursive_train(x, y, w, domain, depth, maxdepth, cost_fn, ...
				cat)

% RECURSIVE_TRAIN generate a tree to recursively train our classifier.
%
% Trees are implemented as structures.  The structure has the following
% attributes:
%
% tree.isterminal = 0
% tree.left  - another tree object, or 'null' if this is a terminal node.
% tree.right - ditto
% tree.splitvar - variable to split on
% tree.splitval - value of variable to split on.  Left is <=, Right is >.
% tree.size - the number of terminal nodes below this node.
% tree.x - the x values in this part of the tree (including all subtrees)
% tree.y - the y values in this part of the tree (including all subtrees)
% tree.w - the w values in this part of the tree (including all subtrees)
% tree.numsamples - number of samples in this part of the tree
% tree.numcorrect - number of samples correctly classified
% tree.numincorrect - number of samples incorrectly classified
% tree.totalweight - amount of weight in this part of the tree
% tree.correctweight - sum of weights of samples correctly classified
% tree.incorrectweight - sum of weights of samples incorrectly classified
%
% This is a nonterminal node.
%
% Alternatively:
%
% tree.isterminal = 1
% tree.size = 1
% tree.category = category (number from 0 to numcategories-1)
% tree.x - the x values in this terminal node
% tree.y - the y values in this terminal node
% tree.w - the w values in this terminal node
% tree.numcorrect - number of samples correctly classified
% tree.numincorrect - number of samples incorrectly classified
% tree.correctweight - sum of weights of samples correctly classified
% tree.incorrectweight - sum of weights of samples incorrectly classified
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
% corresponding category numbers.  W are the weights of each training
% sample.
%
% DEPTH specifies the current recursion depth.  If this number is greater
% than MAXDEPTH, then the function automatically returns 'null'.
%
% CAT specifies the number of categories.
%
% The node will also be marked terminal if all of the data belongs to one
% class.

% Check for the end of recursion.  In this case, simply choose the
% category with the greatest number of samples in y.

if (depth > maxdepth)
   weights = category_weight(y, w, cat);

   max_weight = max(weights);
   max_index = find(weights == max_weight);
   if (length(max_index) > 1)
      category = max_index(1);
   else
      category = max_index;
   end

   % Terminal node
   tree = make_terminal(category-1, x, y, w);
   return;
end

% We also end our recursion if all of our data samples belong to one
% category.
e = (y == y(1));
if (sum(e) == length(y)) % if all elements of e are one (true)
   tree = make_terminal(y(1), x, y, w);
   return;
end

% Find where to split our data
[tree.splitvar, tree.splitval, no_optimal] = ...
   optimal_split(x, y, w, cost_fn, cat);

% If no split decreases the loss function, then recursion is finished.
% In that case, again select the most populous classifier as our terminal
% node.  NOTE that I am not sure if this code will ever be executed -- I
% have a hunch that the previous two cases will preclude this case ever
% being true.
if (no_optimal)
   cats = category_count(y, cat);

   max_count = max(cats);
   max_index = find(cats == max_count);
   if (length(max_index) > 1)
      category = max_index(1);
   else
      category = max_index;
   end

   % Terminal node
   tree = make_terminal(category-1, x, y, w);
   disp('no optimal');
   return;
end

% Split our data about the split point
[left_x, left_y, right_x, right_y, left_w, right_w] = ...
   split_data(x, y, w, tree.splitvar, tree.splitval);

% Recalculate our domain matrices
left_domain_max = domain(1, :);
left_domain_max(tree.splitvar) = tree.splitval;

right_domain_min = domain(2, :);
right_domain_min(tree.splitvar) = tree.splitval;

left_domain  = [left_domain_max; domain(2, :)];
right_domain = [domain(1, :); right_domain_min];

% Recursively call ourself to calculate the left and right trees
tree.left  = recursive_train(left_x,  left_y,  left_w, left_domain, ...
                             depth+1, maxdepth, cost_fn, cat);

tree.right = recursive_train(right_x, right_y, right_w, right_domain, ...
                             depth+1, maxdepth, cost_fn, cat);

% Now, calculate the statistics on this node from the statistics of the
% left and the right nodes.

tree.isterminal = 0;
tree.size = tree.left.size + tree.right.size;

tree.numsamples = tree.left.numsamples + tree.right.numsamples;
tree.numcorrect = tree.left.numcorrect + tree.right.numcorrect;
tree.numincorrect = tree.left.numincorrect + tree.right.numincorrect;

tree.totalweight = tree.left.totalweight + tree.right.totalweight;
tree.correctweight = tree.left.correctweight + tree.right.correctweight;
tree.incorrectweight = tree.left.incorrectweight + tree.right.incorrectweight;

% Finished!







function [var, val, no_optimal] = optimal_split(x, y, w, cost_fn, cat)

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

s = size(x);
dimensions = s(2);

var = 0; val = 0.0; no_optimal = 1;

% In order to calculate an increase/decrease in Q, we need to be know its
% value before we made any split.  This is calculated here.

y_dens = category_weight(y, w, cat) ./ sum(w);
eval(['best_Q = ' cost_fn '(y_dens);']);

for i=1:dimensions

   % Find candidate split points.  Remove the highest one.
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
      left_dens = category_weight(left_y, left_w, cat) ./ sum(left_w);
      right_dens = category_weight(right_y, right_w, cat) ./ sum(right_w);

      % Calculate our left and right Q functions
      eval(['Qleft = '  cost_fn '(left_dens);']);
      eval(['Qright = ' cost_fn '(right_dens);']);

      % Calculate our new impurity
      this_Q = (Qleft .* sum(left_w) + Qright .* sum(right_w)) ./ ...
	       sum(w);

      % If our new impurity is better, then we can be happy and joyous,
      % and record this fact for the calling routine.
      if (this_Q < best_Q + eps)
	 var = i; val = point; best_Q = this_Q; no_optimal = 0;
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

left_index  = find(x(:, splitvar) <= splitval);
right_index = find(x(:, splitvar) >  splitval);

left_x  = x(left_index,  :);
left_y  = y(left_index,  :);
left_w  = w(left_index,  :);

right_x = x(right_index, :);
right_y = y(right_index, :);
right_w = w(right_index, :);






function node = make_terminal(category, x, y, w)

% MAKE_TERMINAL create a terminal node
%
% This function creates a terminal node, given the CATEGORY of the node
% and the X, W and W values of the points that lie within this node.
%
% It automatically calculates the statistics on this node.

node.isterminal = 1;
node.size = 1;
node.category = category;
node.x = x;
node.y = y;
node.w = w;

correct = (y == category);
incorrect = (y != category);

node.numsamples = length(y);
node.numcorrect = sum(correct);
node.numincorrect = sum(incorrect);

node.totalweight = sum(w);
node.correctweight = correct' * w;
node.incorrectweight = incorrect' * w;






function newtree = recursive_prune(tree, x, y, w, lambda)

% RECURSIVE_PRUNE prune a CART tree to obtain a simpler classifier
%
% This function prunes the tree that was generated using the
% RECURSIVE_TRAIN function, in order to generate a simpler tree that
% still performs nearly as well as the original tree.
%
% This is done by trading off between tree complexity and generalisation
% error.  
%
% The specifics: 
%
% The pruning algorithm minimises the model selection criteria which is
% a penalised form of the misclassification risk, given by
%
% Rpen = Remp + lambda * T
%
% where Rpen is the model selection criteria, lambda is a parameter which
% controls how aggresively the model complexity is traded off against
% training error, and the T is the size of the tree (number of terminal
% nodes).
%
% Lambda is generally chosen by resampling techniques on the training
% data.  However, in this routine it is simply a parameter (its optimal
% value will need to be determined elsewhere).
%
% The change in the model selection criteria that would be a result of
% converting a particular node into a terminal node can be calculated
% using just the information at the node as
%
% delta_Rpen = delta_Remp + lambda * delta_T
%
% The pruning routine works by the following algorithm:
%
% REPEAT
%
%   FOREACH nonterminal node in the tree
%      calculate delta_Rpen for this node
%
%   IF min(delta_Rpen) < 0
%   THEN convert this node into a non-terminal
%
% UNTIL min(delta_Rpen >= 0)

% NOTE: I have not actually implemented this code, for the following
% reasons:
%
% * Currently, I am not sure of exactly how to implement the resampling
%   procedure in a reasonably efficient manner.
%
% * Consequently, I would not be able to determine the best value for
%   lambda.
%
% * Thus, I would most likely set lambda to zero anyhow.
%
% * Which does exactly nothing.

newtree = tree; % Temporary, until I get around to implementing it.
