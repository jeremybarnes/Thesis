function testpboost(datatype, numpoints, weaklearner)

% TESTBOOST test the p_boosting algorithm
%
% SYNTAX:
%
% testboost('datatype', numpoints, ['weaklearner'])
%
% This function performs boosting using five different values of the 'p'
% parameter: 0.5, 0.75, 1.0, 1.25, 1.5.
%
% The DATATYPE parameter specifies which distribution the test data is
% drawn from.
%
% The NUMPOINTS parameter specifies the number of data points to use.
%
% The WEAKLEARNER parameter can be one of 'cart' or 'decision_stump', and
% specifies which "weak learner" will be used.

% testpoost.m
% Jeremy Barnes, 27/4/1999
% $Id$

% PRECONDITIONS:
% none


b = category_list('binary');
maxiterations = 1000;

% Construct our weak learner
switch (weaklearner)
   case 'cart'
      wl = cart(b, 2, 'gini', 3);
   case 'decision_stump'
      wl = decision_stump(b, 2);
   otherwise,
      error('testpboost: invalid WEAKLEARNER parameter');
end


% Construct our boosting objects
pvalues = [0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.20 1.40 1.60 1.80 2.00];
%pvalues = [1.00 1.00 1.00 1.00 1.00];
%pvalues = [0.50 0.55 0.60 0.65 0.70 0.75];
%pvalues = [0.60 0.61 0.62 0.63 0.64 0.65];
%pvalues = [0.65 0.66 0.67 0.68 0.69 0.70];
%pvalues = [0.5];

colors = {'r-', 'b-', 'g-', 'k-', 'c-', 'm-', 'r:', 'b:', 'g:', 'k:', 'c:', ...
	  'm:'};

n = length(pvalues);

the_legend = cell(n, 1);
for i=1:n
   the_legend{i} = ['p = ' num2str(pvalues(i))];
end



pboosts = cell(n, 1);

for i=1:n
   pboosts{i} = p_boost(wl, 1000, pvalues(i));
end


% Generate our training and test data
d = dataset(b, 2);
d = datagen(d, datatype, numpoints, 0.05, 0);
[x, y] = data(d);

figure(4);  clf;  dataplot(d);

test_d = dataset(b, 2);
test_d = datagen(test_d, datatype, numpoints, 0, 0);
[xtest, ytest] = data(test_d);


% Complete our initial training step
for i=1:n
   pboosts{i} = trainfirst(pboosts{i}, d);
end


train_error = zeros(n, 1);
test_error = zeros(n, 1);

for i = 1:n
   train_error(i, 1) = training_error(pboosts{i});
   test_error(i, 1) = empirical_risk(pboosts{i}, xtest, ytest);
end

iter = 1;



while (1)
   disp(['Iteration ' num2str(iter)]);

   % plot training error
   figure(1);
   clf;

   hold on;

   for i=1:n
      plot(train_error(i, :), colors{i});
   end

   xlabel('Iteration');
   ylabel('Error');
   title('Training error');

   legend(char(the_legend));


   % plot test error
   figure(2);
   clf;

   hold on;

   for i=1:n
      plot(test_error(i, :), colors{i});
   end

   xlabel('Iteration');
   ylabel('Error');
   title('Test error');

   legend(char(the_legend));


   % Plot b weights
   figure(3);
   clf;

   for i=1:n
      hold on;
      b_plot(pboosts{i}, colors{i});
      title('B weights');
   end

   legend(char(the_legend));

%   figure(5);  clf;
%   marginplot(pboosts{3}, [0 0; 1 1]);
%   hold on;
%   dataplot(d);
%   axis([-0.2 1.2 -0.2 1.2 0 2]); 

   if (iter >= 5)
      pause;
   end

   
   % Now continue training

   trne = zeros(n, 1);
   tste = zeros(n, 1);

   for i=1:n
      if (~aborted(pboosts{i}))
	 pboosts{i} = trainagain(pboosts{i});
      end

      trne(i) = training_error(pboosts{i});
      tste(i) = empirical_risk(pboosts{i}, xtest, ytest);
   end

   train_error = [train_error trne];
   test_error  = [test_error  tste];

   iter = iter + 1;
end


