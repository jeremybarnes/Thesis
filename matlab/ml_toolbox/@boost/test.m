function [trained, test_err, train_err] = test(obj, traind, testd, iterations,option)

% TEST test a BOOST object
%
% SYNTAX:
%
% [trained, train_err, test_err] = test(obj, traind, testd, iterations)
%
% This function exhaustively tests a boost object.  It does this by
% training OBJ many times (ITERATIONS times or until training gets
% aborted) and returning both the test and training error.  The training
% data is passed in TRAIND, and the test data in TESTD.
%
% TRAIND and TESTD are objects of type DATASET that contain the training
% and test datasets repspectively.  They must compatible with OBJ.
%
% The function does not necessarily do things in the order which an
% external function would, and may be considerably faster.
%
% RETURNS:
%
% TRAINED is OBJ trained ITERATIONS times
%
% TEST_ERR is a 1 x ITER vector containing the test error results, where
% ITER is the number of iterations of training that actually occured
% (from 1 to ITERATIONS depending upon when training was aborted).
%
% TRAIN_ERR is the same size as TEST_ERR, but contains the results of
% testing on the test dataset TESTD.
%
% LIMITATIONS:
%
% Currently, it is only sped up for binary classifiers.

% @boost/test.m
% Jeremy Barnes, 22/9/1999
% $Id$

if (nargin == 4)
   option = 'fast';
end

% How it works (binary classifiers):
%
% Since the datasets remain constant, we can be a little smarter about
% how we calculate the test and training errors.  We keep track of the
% margins of all of the data samples.  As we train, we are able to use
% the newly calculated parameters to update the margins; thus we only
% need to execute each weaklearner once.
%
% Every once in a while we do a full recalc to avoid error accumulation
% (although this shouldn't be too much of a problem as we are
% multiplying).

% Get out our x and y values
trainx = x_values(traind);
trainy = y_values(traind);

testx = x_values(testd);
testy = y_values(testd);

test_err = [];
train_err = [];

iter = 1;

if ((numcategories(obj) == 2) & (option ~= 'slow'))
   % Binary classifier

   % Initialisation
   train_margins = zeros(size(trainy));
   test_margins = zeros(size(testy));
   
   % First round of training
   [obj, wl_train_y] = trainfirst(obj, trainx, trainy);
   this_wl = wl_instance(obj, iter);
   wl_test_y = classify(this_wl, testx);
   
   % Update the margins
   train_margins = update_margins(obj, train_margins, wl_train_y);
   test_margins  = update_margins(obj, test_margins,  wl_test_y);
   
   % Calculate errors
   train_err(iter) = sum((train_margins > 0) ~= trainy) / length(trainy);
   test_err (iter) = sum((test_margins  > 0) ~= testy) / length(testy);
   
   while (~aborted(obj) & (iter <= iterations))
      if (mod(iter, 50) == 0)
	 disp(['iteration ' num2str(iter)]);
      end
      
      % Continue training
      [obj, wl_train_y] = trainagain(obj);
      this_wl = wl_instance(obj, iter+1);
      wl_test_y = classify(this_wl, testx);
      
      % Update the margins
      train_margins = update_margins(obj, train_margins, wl_train_y);
      test_margins  = update_margins(obj, test_margins,  wl_test_y);
      
      % Calculate errors
      train_err(iter) = sum((train_margins > 0) ~= trainy) / length(trainy);
      test_err (iter) = sum((test_margins  > 0) ~= testy) / length(testy);
   
      iter = iter + 1;
   end
   
else
   % Not a binary classifier
   
   obj = trainfirst(obj, trainx, trainy);
   train_err = training_error(obj);
   test_err = empirical_risk(obj, testx, testy);
   
   while (~aborted(obj) & (iter <= iterations))
      if (mod(iter, 10) == 0)
	 disp(['iteration ' num2str(iter)]);
      end
      
      obj = trainagain(obj);
      train_err(iter) = training_error(obj);
      test_err (iter) = empirical_risk(obj, testx, testy);
   
      iter = iter + 1;
   end
end

trained = obj;
