function d = load_data(matfile)

% LOAD_DATA create a dataset from a MAT file
%
% SYNTAX:
%
% dataset = load_data('matfile');
%
% This function creates a dataset from the data in a MAT file specified
% as the first argument.  This MAT file is expected to contain the
% following variables:
%
% dimensions -- integer (=d)
% numcategories -- integer (=c)
% x -- double array (r by d)
% y -- double array (r by 1)
%
% RETURNS:
%
% DATASET is a dataset object containing the specified data.

% load_data.m
% Jeremy Barnes, 25/8/1999
% $Id$

load(matfile);

d = dataset(numcategories, dimensions);

d = addsamples(d, x, y);
