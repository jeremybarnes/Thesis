function cat = categories(obj)

% CATEGORIES return the CATEGORY_LIST object of a DATASET
%
% SYNTAX:
%
% cat = categories(obj)
%
% RETURNS:
%
% An object of type CATEGORY_LIST which contains the names and number of
% categories that can appear in the dataset.
%

% labels.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS:
% none


cat = obj.categories;


% POSTCONDITIONS:
check_invarients(obj);


