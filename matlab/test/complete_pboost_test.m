function complete_pboost_test(distribution, dimensions, npoints, noise, ...
			      iterations, trials, trialpoints, ...
			      p, classifier, maxdepth)
% COMPLETE_PBOOST_TEST rigorously test p-bbosting algorithm
%
% SYNTAX:
%
% complete_pboost_test('dataset', dimensions, npoints, noise, ...
%                      iterations, trials, trialpoints, ...
%                      p, 'classifier', [maxdepth])
%
% This function performs multiple tests on the p-boosting
% algorithm.
%
% ITERATIONS iterations of boosting are performed on the
% {weaklearner, p-boosting} pair described by P, CLASSIFIER and
% MAXDEPTH.  P controls the convexity of the p-boosting algorithm;
% CLASSIFIER is one of 'decision_stump' or 'cart', and MAXDEPTH
% controls the depth of the CART object (if CLASSIFIER=='cart').
%
% The data used in the trial are drawn from the DATASET
% distribution with DIMENSIONS dimensions.  See dataset/datagen for
% more details.  Classification noise is controlled by the NOISE
% parameter which specifies the probability of misclassification.
% NPOINTS controls the number of points that are generated.
%
% TRIALS controls the number of times that the test is repeated.
% This allows statistical information to be generated about the
% performance of the classifier.  Each trial generates a .mat file
% in which is saved both the fully trained classifier and the data
% used to generate it (a new dataset is created for each trial).
%
% Once the classifiers have all been trained, they are tested.
% This involves testing the training and testing misclassification
% risk at TRIALPOINTS logarithmetically spaced points.  This is
% done for each of the trials.  Finally, for each of the
% TRIALPOINTS trialled points a mean and variance over the TRIALS
% samples is produced and graphed.  This information is also saved
% in a .mat file.
%
% The global variable DATA_SAVE_PATH is used to determine where to
% put the .mat files.

% test/complete_pboost_test.m
% Jeremy Barnes, 1/7/1999
% $Id$

global data_save_path;

% Check our parameters are valid, and fill in any default values
if (nargin < 9)
   error('complete_pboost_test: not enough arguments');
end

if ((nargin == 9) & (strcmp(classifier, 'cart') == 1))
   error('complete_pboost_test: maxdepth not specified');
end

if (dimensions ~= 2)
   error(['complete_pboost_test: only 2 dimensions currently' ...
	  ' supported']);
end


% The prefix for the .mat files
if (strcmp(classifier,'cart') == 1)
   classifier_name = ['cart-' int2str(maxdepth)];
else
   classifier_name = classifier;
end

prefix = ['pboost-' num2str(p) '-' classifier '-' distribution '-' ...
	  int2str(dimensions) '-' int2str(npoints) '-' num2str(noise) ...
	  '-' int2str(iterations)];


% Set up the support objects needed
b = category_list('binary');
dataset_template = dataset(b, dimensions);

if (strcmp(classifier,'cart') == 1)
   weaklearner = cart(b, dimensions, 'gini', maxdepth);
elseif (strcmp(classifier, 'decision_stump') == 1)
   weaklearner = decision_stump(b, dimensions);
else
   error(['complete_pboost_test: invalid weaklearner class ' ...
	  weaklearner]);
end


% Initialise the random number generator 
rand('state',sum(100*clock));


% Training phase
disp('Training');
disp('--------');

for trial=1:trials

   disp(['trial ' int2str(trial) ' of ' int2str(trials)]); 

   % Check to see that we haven't already done this iteration
   filename = [data_save_path '/' prefix '-trial-' int2str(trial) ...
	       '.mat'];
   
   if (exist(filename, 'file'))
      disp('  --> already calculated');
   
   else % File doesn't exist, so calculate it
      % Get our dataset and our p-boost object
      train_dataset = datagen(dataset_template, distribution, npoints, ...
			      0.0, noise);
      learner = p_boost(weaklearner, p, iterations);
      learner = trainfirst(learner, train_dataset);

      reporting_interval = floor(iterations / 20);
      
      % Training loop
      for iter=2:iterations
	 
	 if (mod(iter, reporting_interval) == 0)
	    disp(['  Iteration ' int2str(iter) ' of ' int2str(iterations)]);
	 end
	 
	 learner = trainagain(learner);
      end
      
      % Write our trained classifier to the file
      
      save(filename, 'learner', 'train_dataset');
   end
end

% Testing phase
disp('Testing');
disp('-------');

% Generate a vector of points at which the classifiers are tested.
% These must be integers, hence the unique and floor commands.

test_points = linspace(1, iterations, test_points);
test_points = logspace(0, log10(iterations), test_points);

test_points = unique(floor(test_points));


                       
