% @classifier/plot_classification.m
% Jeremy Barnes, 4/4/1999
% $Id$
% Time-stamp: <1999-04-04 20:40:49 dosuser>
%
% PLOT_CLASSIFICATION - plot points and the category selected
%
% SYNTAX:
%
% plot_classification(obj, x, y)
% plot_classification(obj, dataset)
%
% Each point in the dataset DATASET or {X, Y} is plotted to show how
% particular points are classified.  Each class is distinguished using a
% different symbol and colour.
%

function plot_classification(obj, filename)

% PRECONDITIONS
% none



% POSTCONDITIONS
check_invariants(obj);

return;

