% @classlabel/labels.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% SYNTAX:
%
% arr = labels(obj)
%
% RETURNS:
%
% arr is a cell array, containing one string for each class label.
%

function arr = labels(obj)

% PRECONDITIONS:
% none

arr = obj.labels;

% POSTCONDITIONS:
global_postconditions(obj)

return;
