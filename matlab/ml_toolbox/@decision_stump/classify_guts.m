function y = classify_guts(obj, x, var, val, leftcat, rightcat)

% CLASSIFY_GUTS the guts of the classification algorithm, minus any
% object oriented code, designed to be implemented in high speed C code.

% @decision_stump/classify_guts.m
% Jeremy Barnes, 17/5/1999
% $Id$

xsplit = x(:, var);
y = (xsplit > val);

% We need to transform y : 0 --> leftcategory and 1 --> rightcategory

y = y .* (rightcat - leftcat) + leftcat;


