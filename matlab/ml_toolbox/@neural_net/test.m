function [trained, train_err, test_err] = test(obj, traind, testd, iterations)

% TEST test a NEURAL_NET over many iterations
%
% SYNTAX:
%
% [trained, train_err, test_err] = test(obj, traind, testd, iterations)
%
% This function exhaustively tests a NEURAL_NET.  It does this by
% training it for ITERATIONS iterations, at each stage calculating
% training error (over the dataset object TRAIND) and test error (over
% the dataset object TESTD).
%
% TRAIND and TESTD are objects of type DATASET that contain the training
% and test datasets repspectively.  They must compatible with OBJ.
%
% RETURNS:
%
% TRAINED is OBJ trained ITERATIONS times
%
% TEST_ERR is a 1 x ITERATIONS vector containing the test error results.
%
% TRAIN_ERR is the same size as TEST_ERR, but contains the results of
% testing on the test dataset TESTD.

% @neural_net/test.m
% Jeremy Barnes, 22/9/1999
% $Id$

% Get out our x and y values
trainx = x_values(traind);
trainy = y_values(traind);

testx = x_values(testd);
testy = y_values(testd);

test_err = [];
train_err = [];

iter = 1;

obj = trainfirst(obj, trainx, trainy);
train_err = empirical_risk(obj, traind);
test_err  = empirical_risk(obj, testd);

while (iter <= iterations)
   obj = trainagain(obj);
   train_err(iter) = empirical_risk(obj, traind);
   test_err (iter) = empirical_risk(obj, testd);
   
   iter = iter + 1;
end

trained = obj;
