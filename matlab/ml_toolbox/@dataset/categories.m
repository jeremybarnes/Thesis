% labels.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% LABELS - returns the labels object of a dataset
%
% SYNTAX:
%
% lab = labels(obj)
%
% RETURNS:
%
% An object of type classlabels which contains the names and number of
% classes that can appear in the dataset.
%

function lab = labels(obj)

% PRECONDITIONS:
% none

lab = obj.labels;

% POSTCONDITIONS:
check_invarients(obj);

return;


