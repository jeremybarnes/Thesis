function c = numcategories(obj)

% NUMCATEGORIES return number of categories in a classifier
%
% SYNTAX:
%
% c = numcategories(obj)
%
% RETURNS:
%
% C is the number of categories in output space of OBJ.

% @classifier/numcategories.m
% Jeremy Barnes, 18/8/1999
% $Id$

c = obj.numcategories;
