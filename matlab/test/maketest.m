function maketest(name, algorithm, p, dist, samples, noise, numiterations, trials)

% MAKETEST create a mat file which describes a test
%
% SYNTAX:
%
% maketest('name', 'algorithm', p, 'dist', samples, noise, iterations, trials)
%
% This function creates a .mat file in the directory pointed to by the
% global variable DATA_SAVE_PATH.  This file completely describes a test
% that is to be performed on a variant of the boosting algorithm.
%
% NAME is a string that is the name of the test.  It also controls the
% name of the MAT file.
%
% ALGORITHM is one of 'boost', 'normboost' or 'normboost2', and tells
% which variant to use.
%
% P is the p value to be used for the normboost or normboost2 variants.
% This may be a vector, in which case all will be tried.
%
% DIST is a distribution passed to datagen.
%
% SAMPLES is the number of samples to generate.
%
% NOISE is the amount of noise to add to the samples (0 to 1).  This may
% be a vector, in which case all will be tried.
%
% ITERATIONS is the number of rounds of boosting to attempt each time.
% If training aborts early, then this number may not be able to be
% reached.
%
% TRIALS is the number of trials to perform.
%
% Note that decision stumps are always used for the weak learner.
%
% In order to run a test, use the RUNTEST command.

% maketest.m
% Jeremy Barnes, 23/9/1999
% $Id$

global DATA_SAVE_PATH;

if (isempty(DATA_SAVE_PATH))
   error('maketest: must set DATA_SAVE_PATH global variable');
end

% Try to create a directory for the test
dirname = [DATA_SAVE_PATH '/' name];
exec(['!mkdir ' dirname], 'disp(''mkdir failed'';)');

filename = [DATA_SAVE_PATH '/' name '/' name '.mat'];

save(filename, 'name', 'algorithm', 'p', 'dist', 'samples', 'noise', ...
     'numiterations', 'trials');

