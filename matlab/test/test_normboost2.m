function test_normboost2(p, datatype, numpoints, noise)

% TEST_NORMBOOST2 test my implementation of the boosting algorithm
%
% SYNTAX:

% test_normboost2.m
% Jeremy Barnes, 23/8/1999
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
boost2 = normboost2(wl, p);

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
