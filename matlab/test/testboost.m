function testboost(datatype, numpoints, num_iter)

% TESTBOOST test my implementation of the boosting algorithm
%
% SYNTAX:
%
% testboost('datatype', numpoints)
%
% This function tests out the boosting algorithm.  It changes often.

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
d = datagen(d, datatype, numpoints, 0, 0.2);
[x, y] = data(d);

test_d = dataset(b, 2);
test_d = datagen(test_d, datatype, 5000, 0, 0);
[xtest, ytest] = data(test_d);

% Do the testing
[trained, test_err, train_err] = test(boost1, d, test_d, num_iter, 'nosave');
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
