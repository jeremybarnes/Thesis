function n = dimensions(obj)

% DIMENSIONS return the number of dimensions of the classifier
%
% SYNTAX:
%
% n = dimensions(obj)
%
% RETURNS:
%
% N is the number of dimensions of the independent variable that the
% classifier OBJ expects.  This is specified in the constructor of the
% classifier.

% @classifier/dimensions.m
% Jeremy Barnes, 4/4/1999
% $Id$

obj = classifier(obj);
n = obj.dimensions;
