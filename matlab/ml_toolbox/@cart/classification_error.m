function e = classification_error(obj, x, y, w)

% CLASSIFICATION_ERROR return the classification error of a CART object
%
% SYNTAX:
%
% e = classification_error(obj, x, y, [w])
% e = classification_error(obj, dataset, [w])
%
% RETURNS:
%
% The training error is the sum of the weights of samples that are
% classified incorrectly.  This is returned in E.  The {X, Y} parameter
% can either be specified as a DATASET class or via individual variables.
%
% The W vector contains the weight (relative importance) of each data
% point.  If not specified, it defaults to all ones.  This has the result
% of E being the number of points that are classified incorrectly.

% @cart/classification_error.m
% Jeremy Barnes 22/4/1999
% $Id$

% FIXME: no default values for w if {x,y} instead of dataset given
% FIXME: this code is the same as in train, should be in separate
% function

% PRECONDITIONS
if (isa(x, 'dataset'))
   if (numcategories(categories(x)) ~= numcategories(obj.categories))
      error(['classification_error: numcategories in dataset and classifier'...
	     ' don''t match']);

   end
   if (dimensions(x) ~= obj.dimensions)
      error(['classification_error: dimensionality of dataset and' ...
	     ' classifier don''t match']);

   end
   if (nargin == 3) % we have weights
      [x, y] = data(x); % extract the data
      w = y;
   elseif (nargin < 3) % no weights
      [x, y] = data(x); % extract the data
      w = ones(length(y), 1); % create equal weights
   else
      error('classification_error: too many arguments given');
   end
elseif (~(isa(x, double)))
   error('classification_error: first parameter must be dataset or array');
else
   s = size(x);
   if (length(s) ~= 2)
      error('classification_error: incorrect dimensionality for x vector');
   elseif (length(y) ~= s(1))
      error('classification_error: length of x and y do not match');
   end
   m = max(y);
   if (m >= numcategories(obj.categories))
      error(['classification_error: too many categories in y for this' ...
	     ' classifier']);
   end
   if (fix(y) ~= y)
      error('classification_error: fractional category values in y');
   end
end

if (length(w) != length(y))
   error(['classification_error: weight vector must be the same length as' ...
	  ' data']);
end


% Classify the data
yc = classify(obj, x);

% Find which ones are wrong
ywrong = (yc != y);

% Find the total weight of wrong answers
weightwrong = sum(ywrong .* w);

% Find the proportion of wrong weight
e = weightwrong / sum(w);

% POSTCONDITIONS:
check_invariants(obj);
