function tree = recursive_train(obj, x, y, w, domain, depth, maxdepth, ...
				cost_fn, cat)

% RECURSIVE_TRAIN generate a tree to recursively train our classifier.
%
% NOTE: this code is designed to be implemented in high-speed C in a MEX
% file, and thus will not normally be called.
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

% @cart/recursive_train.m
% Jeremy Barnes, 17/5/1999
% $Id$

% Check for the end of recursion.  In this case, simply choose the
% category with the greatest number of samples in y.

obj = cart(obj);

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
eval(['[tree.splitvar, tree.splitval, no_optimal] = optimal_split_' cost_fn ...
      '(obj, x, y, w, cat);']);

% If no split decreases the loss function, then recursion is finished.
% In that case, again select the most populous classifier as our terminal
% node.  NOTE that I am not sure if this code will ever be executed -- I
% have a hunch that the previous two cases will preclude this case ever
% being true.
if (no_optimal)
   cats = category_weight(y, w, cat);

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
tree.left  = recursive_train(obj, left_x,  left_y,  left_w, left_domain, ...
                             depth+1, maxdepth, cost_fn, cat);

tree.right = recursive_train(obj, right_x, right_y, right_w, right_domain, ...
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

