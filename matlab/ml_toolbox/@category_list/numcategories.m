function n = numcategories(obj)

% NUMCATEGORIES number of categories in a CATEGORY_LIST
%
% SYNTAX:
%
% n = numcategories(obj)
%
% RETURNS:
%
% N is the number of labels stored in OBJ.

% @category_list/numcategories.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS
% none


n = obj.numcategories;


% POSTCONDITIONS
check_invariants(obj);
