function arr = categories(obj)

% CATEGORIES return cell array of all categories
%
% SYNTAX:
%
% arr = categories(obj)
%
% RETURNS:
%
% ARR is a cell array, containing one string for each category in OBJ.

% @category_list/numcategories.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS:
% none


arr = obj.categories;


% POSTCONDITIONS:
check_invariants(obj)
