% @classifier/plot_decision_boundary.m
% Jeremy Barnes, 4/4/1999
% $Id$
% Time-stamp: <1999-04-04 20:45:00 dosuser>
%
% PLOT_CLASSIFICATION - plot the decision boundary of a 2D classifier
%
% SYNTAX:
%
% plot_decision_boundary(obj)
%
% Attempts to discover and plot the decision boundary of a classifier.
% This is done by scanning both horizontally and vertically along the
% sample space, looking for changes in classification and homing in on
% these.  The final plot looks quite crude, but can be used to gain an
% indication of the location of the decision boundary.
%

function plot_decision_boundary(obj, filename)

% PRECONDITIONS
% none



% POSTCONDITIONS
check_invariants(obj);

return;

