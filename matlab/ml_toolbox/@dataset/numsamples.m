% numsamples.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% NUMSAMPLES - returns the number of observations of a dataset
%
% SYNTAX:
%
% n = numsamples(obj)
%
% RETURNS:
%
% The number of observations in a dataset.  Both the SAMPLES and CLASSES
% methods will return an array which has this number of rows.
%
% Basically, it is the size of the dataset.

function n = numsamples(obj)

n = obj.numsamples;
