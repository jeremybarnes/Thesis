function n = categories(obj)

% CATEGORIES category list of a classifier
%
% SYNTAX:
%
% lst = categories(obj)
%
% RETURNS:
%
% LST is an object of type CATEGORY_LIST that describes the catagories
% that the dependent variable can range over.

% @classifier/categories.m
% Jeremy Barnes, 4/4/1999
% $Id$

obj = classifier(obj);
n = obj.categories;
