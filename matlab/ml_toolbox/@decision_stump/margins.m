function m = margins(obj, x)

% MARGINS return vector of margins on training data
% FIXME: comment
% Correct classifications are positive.  Incorrect are negative.

% @decision_stump/margins.m
% Jeremy Barnes, 11/5/1999
% $Id$

% Well, we don't exactly know which is correct and which is not... so we
% will simply make them all positive.  The amount by which they are, is
% simply the distance from the dividing line.  Pretty simple, huh.

xvar = x(:, obj.splitvar);
m = abs(xvar - obj.splitval);


