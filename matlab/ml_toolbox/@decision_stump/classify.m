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
% The categories in Y.

% @decision_stump/classify.m
% Jeremy Barnes, 25/4/1999
% $Id$

% This one is pretty simple -- just find which points are less than the
% variable we split on, give a y value for each of these as leftcategory,
% and the others rightcategory.

% PRECONDITIONS
% none
% FIXME: preconditions

% Check for trivial case

if (isempty(x))
   y = [];
   return;
end

xsplit = x(:, obj.splitvar);
y = (xsplit > obj.splitval);

% We need to transform y : 0 --> leftcategory and 1 --> rightcategory

y = y .* (obj.rightcategory - obj.leftcategory) + obj.leftcategory;


% POSTCONDITIONS
check_invariants(obj);
