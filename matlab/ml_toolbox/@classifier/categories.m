function n = classes(obj)
% CLASSES classlabels of a classifier
%
% SYNTAX:
%
% n = classes(obj)
%
% RETURNS:
%
% N is the number of dimensions of the independent variable that the
% classifier OBJ expects.  This is specified in the constructor of the
% classifier.

% @classifier/classes.m
% Jeremy Barnes, 4/4/1999
% $Id$

% PRECONDITIONS
% none

n = obj.classes;

% POSTCONDITIONS
check_invariants(obj);

return;