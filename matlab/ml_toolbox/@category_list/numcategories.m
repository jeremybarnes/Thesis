% @classlabel/numlabels.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% SYNTAX:
%
% n = numlabels(obj)
%
% RETURNS:
%
% Number of labels stored in this class.
%

function n = numlabels(obj)

% PRECONDITIONS
% none

n = obj.numlabels;

% POSTCONDITIONS
global_postconditions(obj);

return;

