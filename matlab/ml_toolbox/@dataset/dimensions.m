% dimensions.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% DIMENSIONS - returns the number of dimensions of the independent
%              variable of a dataset
%
% SYNTAX:
%
% dim = dimensions(obj)
%
% RETURNS:
%
% The number of dimensions of the independent variable in the dataset.
%

function dim = dimensions(obj)

% PRECONDITIONS:
% none

dim = obj.dimensions;

% POSTCONDITIONS:
check_invarients(obj);

return;


