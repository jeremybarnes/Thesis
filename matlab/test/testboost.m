function testboost(datatype, numpoints, num_iter)

% TESTBOOST test my implementation of the boosting algorithm
%
% SYNTAX:
%
% testboost('datatype', numpoints)
%
% This function tests out the boosting algorithm in the following manner:
%
% 1)  It constructs two weak learners: one using the CART algorithm
%     with a MAXDEPTH of 4, and one using the DECISION_STUMPS algorithm.
%
% 2)  It constructs two "boost" classifiers based upon these two weak
%     learners.
%
% 3)  It generates a dataset, and begins to train the weak learners on
%     this dataset.
%
% 4)  After each training set, the training error of each of the boosted
%     algorithms is calculated.  This is plotted against iteration number
%     to compare both of the classifiers.
%
% 5)  A weight density plot is also created for each of the classifiers,
%     to enable a visualisation of how the weight densities evolve over
%     time.
%
% 6)  The user presses any key to continue.

% testboost.m
% Jeremy Barnes, 25/4/1999
% $Id$

% PRECONDITIONS:
% none

if (nargin == 2)
   num_iter = 10;
end


% Set up our classifiers
b = category_list('binary');
maxiterations = 100;

wl2 = cart(b, 2, 'gini', 3);
wl1 = decision_stump(b, 2);

boost1 = boost(wl1);
boost2 = boost(wl2);

d = dataset(b, 2);
d = datagen(d, datatype, numpoints, 0, 0.1);
[x, y] = data(d);

test_d = dataset(b, 2);
test_d = datagen(test_d, datatype, 1000, 0, 0);
[xtest, ytest] = data(test_d);

% Complete our initial training step

boost1 = trainfirst(boost1, d);
%boost2 = trainfirst(boost2, d);

train_error1 = training_error(boost1);
%train_error2 = training_error(boost2);
%disp(['Training error (boost2) = ' num2str(train_error2)]);

test_error1 = empirical_risk(boost1, xtest, ytest);
%test_error2 = empirical_risk(boost2, xtest, ytest);

iter = 1;

train_points = logspace(1, num_iter, 100);

tic;

while (1)
   disp(['Iteration ' num2str(iter)]);

   % Calculation phase
   if (~aborted(boost1))
      boost1 = trainagain(boost1);
   end

   te1 = training_error(boost1);
   train_error1 = [train_error1 te1];
   test_error1 = [test_error1 empirical_risk(boost1, xtest, ytest)];

%   if (~aborted(boost2))
%      boost2 = trainagain(boost2);
%   end
%   te2 = training_error(boost2);
%   train_error2 = [train_error2 te2];
%   test_error2 = [test_error2 empirical_risk(boost2, xtest, ytest)];

   if (iter == num_iter)
      toc

      figure(1);
      clf;

      % First error plot
      subplot(2, 1, 1);
      plot(train_error1, 'b-');
      hold on;
      plot(test_error1, 'r-');
      
      xlabel('Iteration');
      ylabel('Error');
      
      legend('training error', 'test error');
      
%      % Second error plot
%      subplot(2, 1, 2);
%      plot(train_error2, 'b-');
%      hold on;
%      plot(test_error2, 'r-');
      
%      xlabel('Iteration');
%      ylabel('Error');
      
%      legend('training error', 'test error');
      return;
   end
      
   iter = iter + 1;
end


