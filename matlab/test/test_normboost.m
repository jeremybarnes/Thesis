function test_normboost(p, datatype, numpoints, noise)

% TEST_NORMBOOST test my implementation of the boosting algorithm
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

if (nargin == 0)
   p = 1.0;
   datatype = 'ring';
   numpoints = 15;
   noise = 0.1;
elseif (nargin == 1)
   datatype = 'ring';
   numpoints = 15;
   noise = 0.1;
elseif (nargin == 2)
   numpoints = 15;
   noise = 0.1;
elseif (nargin == 3)
   noise = 0.1;
end


% Set up our classifiers
b = category_list('binary');
maxiterations = 100;

wl = decision_stump(b, 2);

boost1 = boost(wl);
boost2 = normboost(wl, p);

d = dataset(b, 2);
d = datagen(d, datatype, numpoints, 0, noise);
[x, y] = data(d);

% Complete our initial training step

boost1 = trainfirst(boost1, d);
boost2 = trainfirst(boost2, d);

iter = 1;

while (1)
   disp(['Iteration ' num2str(iter)]);

   % Calculation phase
   if (~aborted(boost1))
      boost1 = trainagain(boost1);
   end

   if (~aborted(boost2))
      boost2 = trainagain(boost2);
   end

   pause;
      
   iter = iter + 1;
end
