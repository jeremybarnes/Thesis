function [x, y] = data(obj)

% DATA return data stored in a dataset
%
% SYNTAX:
%
% [x, y] = data(obj)
%
% RETURNS:
%
% X contains a mxn matrix where m is the number of samples and n is
% dimension of the input variable, which contains the values of the
% independent variable, one per row.
%
% Y contains a mx1 matrix which contains the category values of the data.

% @dataset/data.m
% Jeremy Barnes, 6/5/1999
% $Id$

% PRECONDITIONS:
% none

x = obj.x_values;
y = obj.y_values;

% POSTCONDITIONS:
check_invariants(obj);
