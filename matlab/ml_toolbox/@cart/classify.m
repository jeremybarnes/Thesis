function y = classify(obj, x)

% CLASSIFY classify a set of data
%
% SYNTAX:
%
% y = classify(obj, x)
%
% Classifies the data in X using the classifier OBJ.  Returns the class
% labels in Y.
%
% RETURNS:
%
% The class labels in Y.

% @cart/classify.m
% Jeremy Barnes, 22/4/1999
% $Id$

% The tree is traversed recursively, at each point splitting the input
% data on the split variable, until a terminal node is reached.  The
% results are then passed upwards through the tree as the recursive
% procedures return, being reassembled as they go.
%
% This allows for efficient classification of larger datasets.  It may be
% less than optimal for smaller datasets.


% PRECONDITIONS
% none


% The work is done in the recursive function below
y = recursive_classify(obj.tree, x);


% POSTCONDITIONS
check_invariants(obj);






function y = recursive_classify(tree, x)

% FIXME: comment

% Check for trivial case

if (isempty(x))
   y = [];
   return;
end

% Check for a terminal node
xs = size(x);

if (tree.isterminal)
   y = ones(xs(1), 1) .* tree.category;
   return;
end

% If we reach this point, then we have a subtree to contend with.  We
% need to split our data on the specified variable (just as in the train
% method) and recursively call this procedure for each of the left and
% right trees.  However, we must be very careful to keep track of the
% order of our data samples, so that we can eventually reconstruct them
% in the same order they were in.

% First, split it up
[left_x, left_index, right_x, right_index] = ...
    split_data(x, tree.splitvar, tree.splitval);

% Now pass it along to be classified
left_y  = recursive_classify(tree.left,  left_x);
right_y = recursive_classify(tree.right, right_x);

% And put it all back together.
[x, y] = merge_data(left_x, left_y, left_index, right_x, right_y, ...
		    right_index);








function [left_x, left_index, right_x, right_index]  ...
   = split_data(x, splitvar, splitval);

% SPLIT_DATA separate a dataset by splitting on value of one variable
%
% FIXME: comment needs modification
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
right_x = x(right_index, :);








function [x, y] = merge_data(left_x,  left_y,  left_index, ...
			     right_x, right_y, right_index)
% MERGE_DATA merge together a dataset split using SPLIT_DATA

sxl = size(left_x);
sxr = size(right_x);

x_length = sxl(1) + sxr(1);

% Pre-allocate for efficiency
x = zeros(x_length, sxl(2));
y = zeros(x_length, 1);

% Put it all back together
x(left_index, :) = left_x;
y(left_index, 1) = left_y;

x(right_index, :) = right_x;
y(right_index, 1) = right_y;
