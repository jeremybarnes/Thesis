function investigate_strict(p)

% INVESTIGAGE_STRICT find out what is up with strict training

% testboost.m
% Jeremy Barnes, 25/4/1999
% $Id$

global state

%state = sum(100*clock);  % Random state
state = 214646; % This state leads to one which doesn't work.
rand('state', state); 

if (nargin == 0)
   p = 0.5;
end

datatype = 'ring';
numpoints = 10;
noise = 0.1;

maxiterations = 10;

% Set up our classifiers

wl = decision_stump(2, 2);

alg = strict_test(wl, p);



d = dataset(2, 2);
d = datagen(d, datatype, numpoints, 0, noise);
[x, y] = data(d);

% Complete our initial training step

alg= trainfirst(alg, d);

iter = 1;

while (iter < maxiterations)
   disp(['Iteration ' num2str(iter)]);

   % Calculation phase
   if (~aborted(alg))
      alg = trainagain(alg);
   end
      
   iter = iter + 1;
end
