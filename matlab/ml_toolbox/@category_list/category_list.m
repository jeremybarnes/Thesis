function obj = category_list(categories)

% CATEGORY_LIST list of categories for classification
%
% This is the constructor for the class CATEGORY_LIST
%
% SYNTAX:
%
% obj = category_list({'label0', 'label1', ...})
%
% This type holds information about the labels of classes us used in a
% classifier.  You pass it a list of textual labels, which correspond to
% the classes of your data.  They are mapped onto the numbers 0, 1,
% 2,...
%
% obj = classlabel('binary')
%
% This is equivalent to obj=classlabel({'false', 'true'})
%
% RETURNS:
%
% A CATEGORY_LIST object with the specified labels.
%
% METHODS:
%
% numcategories(obj)
%    - returns the number of categories
%
% categories(obj)
%    - returns a cell array of the category labels
%
% categorynum(obj, i)
%    - returns the label for category number i

% @category_list/category_list.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS
if (length(categories) == 0)
   error('You must specify at least one category');
end

if (isa(categories, 'double') | isa(categories, 'char'))
   switch categories
      case 'binary'
	 categories = {'false', 'true'};
      otherwise,
	 error(['classlabel: unknown class type "' categories '"']);
   end
end

% initialisation of variables in obj
obj.initialised = 1;
obj.numcategories = length(categories);
obj.categories = categories;


% construct class and define superior/inferior relationship
obj = class(obj, 'category_list');
superiorto('double');



% POSTCONDITIONS
check_invariants(obj);


