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

if (nargin == 2)
   num_iter = 500;
end


% Set up our classifier
b = category_list('binary');
maxiterations = 100;

wl = decision_stump(b, 2);

boost1 = boost(wl);

d = dataset(b, 2);
d = datagen(d, datatype, numpoints, 0, 0.1);
[x, y] = data(d);

test_d = dataset(b, 2);
test_d = datagen(test_d, datatype, 5000, 0, 0);
[xtest, ytest] = data(test_d);

% Do the testing
[trained, test_err, train_err] = test(boost1, d, test_d, num_iter);
%[trained2, test_err2, train_err2] = test(boost1, d, test_d, num_iter, 'slow');

% Plot the results
figure(1);  clf;

iter = 1:length(test_err);
semilogx(iter, test_err, 'r-');  hold on;
semilogx(iter, train_err, 'b-');
%plot(iter, test_err2, 'c--');
%plot(iter, train_err2, 'm--');
xlabel('iterations');  ylabel('error');
legend('test error', 'training error');
%, 'slow test error', ['slow training' ...  ' error']);
