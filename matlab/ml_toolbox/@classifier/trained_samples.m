% @classifier/trained_samples.m
% Jeremy Barnes, 4/4/1999
% $Id$
% Time-stamp: <1999-04-04 22:18:00 dosuser>
%
% TRAINED_SAMPLES - number of samples a classifier has been trained on
%
% SYNTAX:
%
% n = trained_samples(obj)
%
% RETURNS:
%
% The number of samples that have been used to train this classifier.
%

function n = trained_samples(obj)

% PRECONDITIONS
% none

n = obj.trained_samples;

% POSTCONDITIONS
check_invariants(obj);

return;function n = trained_samples(obj)

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
