function x = x_values(obj)

% X_VALUES returns x (independent) variable values of dataset
%
% SYNTAX:
%
% x = x_values(obj)
%
% RETURNS:
%
% An array of size (NUMSAMPLES x DIMENSIONS) is returned, which contains
% all of the independent (x) values of the data, one sample per row.

% @dataset/x_values.m
% Jeremy Barnes, 3/4/1999
% $Id$

% PRECONDITIONS:
% none

x = obj.x_values;

% POSTCONDITIONS:
check_invariants(obj);



