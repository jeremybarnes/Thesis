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

y = classify_guts(obj, x, obj.splitvar, obj.splitval, obj.leftcategory, ...
		  obj.rightcategory);

% POSTCONDITIONS
check_invariants(obj);




