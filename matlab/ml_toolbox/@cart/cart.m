function obj = cart(categories, dimensions, cost_fn, maxdepth)

% CART classifier using C.A.R.T. algorithm
%
% This is the constructor for the cart classifier type.
%
% SYNTAX:
%
% obj = cart(categories, dimensions, 'cost_fn', maxdepth)
%
% Creates a classifier based on the "Classification And Regression Trees"
% algorithm.  This is a tree-based algorithm that was developed by Jerome
% Friedman and others at Stanford University.
%
% The tree approach splits the input space into disjoint regions, each of
% which have exactly one classification value.  The splitting is done one
% one variable, splitting that axis into two parts.  Candidate split
% points for each axis are the set of values of that particular variable.
% Thus, if there are m dimensions (independent variables) and n data
% samples, there are n candidate split points for each axis to give a
% total of mn split points.
%
% The actual split point is chosen using a greedy rule.  The greedy rule
% simply minimises the cost function at the point.  There are several
% possibile cost functions, which have different strengths.  The rule is
% specified in the COST_FN parameter, which can be one of the following:
%
%  'misclassification'
%  'gini'
%  'entropy'
%
% For more information, see the book "Learning From Data: Concepts,
% Theory and Methods" by Cherkassky and Mulier. 
%
% RETURNS:
%
% OBJ is the new classifier.

% @cart/cart.m
% Jeremy Barnes, 4/4/1999
% $Id$


% PRECONDITIONS
switch cost_fn
   case {'misclassification', 'gini', 'entropy'}
   otherwise,
      error(['cart: cost function "' cost_fn '" is unknown']);
end

if (maxdepth < 1)
   error('cart: MAXDEPTH must be >= 1');
end


% ancestor relationship
parent = classifier(categories, dimensions);

% initialisation of variables in obj
obj.cost_fn = cost_fn;
obj.maxdepth = maxdepth;
obj.dimensions = dimensions;
obj.categories = categories;

% Our root tree, which does exactly nothing.
obj.tree = 0;

% construct class and use superior/inferior relationship
obj = class(obj, 'cart', parent);
superiorto('double', 'classifier');


% POSTCONDITIONS
check_invariants(obj);

return;