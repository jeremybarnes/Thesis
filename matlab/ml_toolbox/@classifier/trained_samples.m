function n = trained_samples(obj)

% TRAINED_SAMPLES - number of samples a classifier has been trained on
%
% SYNTAX:
%
% n = trained_samples(obj)
%
% RETURNS:
%
% The number of samples that have been used to train this classifier.

% @classifier/trained_samples.m
% Jeremy Barnes, 4/4/1999
% $Id$

n = obj.trained_samples;
