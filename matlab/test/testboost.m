function testboost(datatype, numpoints)

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

% Set up our classifiers
b = category_list('binary');
maxiterations = 100;

wl1 = cart(b, 2, 'gini', 4);
wl2 = decision_stump(b, 2);

boost1 = boost(wl1, 100);
boost2 = boost(wl2, 100);

d = dataset(b, 2);
d = datagen(d, datatype, numpoints, 0, 0);
[x, y] = data(d);

test_d = dataset(b, 2);
test_d = datagen(d, datatype, numpoints, 0, 0);
[xtest, ytest] = data(d);

% Complete our initial training step
boost1 = trainfirst(boost1, d);
boost2 = trainfirst(boost2, d);

train_error1 = training_error(boost1);
train_error2 = training_error(boost2);

test_error1 = empirical_risk(boost1, xtest, ytest);
test_error2 = empirical_risk(boost2, xtest, ytest);


str = '';
iter = 1;

while (str ~= 'q')
   disp(['Iteration ' num2str(iter)]);

   figure(1);

   % First error plot
   subplot(2, 2, 2);
   plot(train_error1);
   hold on;
   plot(test_error1);

   xlabel('Iteration');
   ylabel('Error');
   
   legend('training error', 'test error');

   % Second error plot
   subplot(2, 2, 4);
   plot(train_error2);
   hold on;
   plot(test_error2);

   xlabel('Iteration');
   ylabel('Error');

   legend('training error', 'test error');

   % First density plot
   subplot(2, 2, 1);
   weight_density_plot(boost1);

   % Second density plot
   subplot(2, 2, 3);
   weight_density_plot(boost2);

   
   % Now recalculate everything
   boost1 = trainagain(boost1);
   boost2 = trainagain(boost2);
   
   train_error1 = [train_error1 training_error(boost1)];
   train_error2 = [train_error2 training_error(boost2)];
   
   test_error1 = [test_error1 empirical_risk(boost1, xtest, ytest)];
   test_error2 = [test_error2 empirical_risk(boost2, xtest, ytest)];

   str = input('Press <enter> to continue, or <q><enter> to stop');
end


function testboost(datatype, numpoints)

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

% Set up our classifiers
b = category_list('binary');
maxiterations = 100;

wl1 = cart(b, 2, 'gini', 3);
wl2 = decision_stump(b, 2);

boost1 = boost(wl1, 100);
boost2 = boost(wl2, 100);

d = dataset(b, 2);
d = datagen(d, datatype, numpoints, 0, 0);
[x, y] = data(d);

test_d = dataset(b, 2);
test_d = datagen(d, datatype, numpoints, 0, 0);
[xtest, ytest] = data(test_d);

% Complete our initial training step

boost1 = trainfirst(boost1, d);
boost2 = trainfirst(boost2, d);

train_error1 = training_error(boost1);
train_error2 = training_error(boost2);
%disp(['Training error (boost2) = ' num2str(train_error2)]);

test_error1 = empirical_risk(boost1, xtest, ytest);
test_error2 = empirical_risk(boost2, xtest, ytest);

iter = 1;


while (1)
   disp(['Iteration ' num2str(iter)]);

   figure(1);
   clf;

   % First error plot
   subplot(2, 2, 2);
   plot(train_error1, 'b-x');
   hold on;
   plot(test_error1, 'r-o');

   xlabel('Iteration');
   ylabel('Error');
   
   legend('training error', 'test error');

   % Second error plot
   subplot(2, 2, 4);
   plot(train_error2, 'b-x');
   hold on;
   plot(test_error2, 'r-o');

   xlabel('Iteration');
   ylabel('Error');

   legend('training error', 'test error');

%   if (mod(iter, 5) == 0)
      % First density plot
      subplot(2, 2, 1);
      weight_density_plot(boost1);

      % Second density plot
      subplot(2, 2, 3);
      weight_density_plot(boost2);
%   end

%   figure(2);
%   clf;
%   dataplot(d, 'r.', 'b.');
%   testy = classify(boost1, x);
%   testd = addsamples(dataset(b, 2), x, testy);
%   hold on;
%   dataplot(testd, 'ro', 'bo');

   
   % Now recalculate everything

   if (~aborted(boost1))
      boost1 = trainagain(boost1);
   end

   te1 = training_error(boost1);
%   disp(['Training error (boost1) = ' num2str(te1)]);

   train_error1 = [train_error1 te1];
   test_error1 = [test_error1 empirical_risk(boost1, xtest, ytest)];


      
   if (~aborted(boost2))
      boost2 = trainagain(boost2);
   end

   te2 = training_error(boost2);
%   disp(['Training error (boost2) = ' num2str(te2)]);

   train_error2 = [train_error2 te2];
   test_error2 = [test_error2 empirical_risk(boost2, xtest, ytest)];

%   if (mod(iter, 5) == 0)
%      disp('Press any key to continue...');
%      pause;
%   end

   iter = iter + 1;
   if (iter == 26)
      return;
   end
end


