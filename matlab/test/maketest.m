function maketest

% MAKETEST create a mat file which describes a test (interactive)
%
% SYNTAX:
%
% maketest
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

name = input('Name of test: ', 's');

% Try to create a directory for the test
dirname = [DATA_SAVE_PATH '/' name];
eval(['!mkdir ' dirname], 'disp(''mkdir failed'';)');

filename = [DATA_SAVE_PATH '/' name '/' name '.mat'];

disp(['Creating test file in ' filename]);

algorithm = input('algorithm to use: ', 's');
p = input('p value(s) to use: ');
choice = input('[1] distribution or [2] dataset: ');

if (choice == 1)
   datatype = 'distribution';
   dist = input('Which distribution: ', 's');
   samples = input('Number of samples: ');
   noise = input('Amount(s) of noise to add: ');
   dataset_name = '';
   split = 0;
else
   datatype = 'dataset';
   dataset_name = input('Which dataset: ', 's');
   split = input('Training partition (<1 = proportion, >1 = samples): ');
   noise = 0;
   samples = 0;
   dist = '';
end

numiterations = input('Number of iterations to train to: ');
trials = input('Number of independent trials: ');

this_test.name = name;
this_test.algorithm = algorithm;
this_test.p = p;
this_test.dist = dist;
this_test.samples = samples;
this_test.noise = noise;
this_test.dataset_name = dataset;
this_test.datatype = datatype;
this_test.split = split;
this_test.numiterations = numiterations;
this_test.trials = trials;

save(filename, 'name', 'algorithm', 'p', 'dist', 'samples', 'noise', ...
     'dataset_name', 'split', 'numiterations', 'trials', 'datatype', ...
     'this_test');

