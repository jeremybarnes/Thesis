% @classifier/dimensions.m
% Jeremy Barnes, 4/4/1999
% $Id$
% Time-stamp: <1999-04-04 22:28:22 dosuser>
%
% DIMENSIONS - returns the number of dimensions of the classifier
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
%

function n = dimensions(obj)

% PRECONDITIONS
% none

n = obj.dimensions;

% POSTCONDITIONS
check_invariants(obj);

return;