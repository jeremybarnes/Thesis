function plot_cost_function

% PLOT_COST_FUNCTION plot the cost function of a dataset

% plot_cost_function.m
% Jeremy Barnes, 2/8/1999
% $Id$

global train_x train_y train_data

% constants
noise = 0.1;
samples = 20;
distribution = 'ring';
start_iter = 20;

% Weaklearner
binary = category_list('binary');
wl = decision_stump(binary, 2);

% Boosting algorithm
boost1 = boost(wl);
   
% Generate our training dataset
train_data = dataset(binary, 2);
train_data = datagen(train_data, distribution, samples, 0, noise);
train_x = x_values(train_data);
train_y = y_values(train_data)*2 - 1;

%   figure(1);  clf;  dataplot(train_data);

% Set up our boosting parameters
iterations = 0;
weaklearners = [];
my_classifier_weights = [];  % AKA b
my_sample_weights = ones(samples, 1) * (1/samples); % AKA w

% Rows = weak learners, cols = training samples
training_results = ones(0, length(train_y)); % So we don't re-evaluate
					     % many times
training_errors = [];

train_iter = 10;


% Train boosting algorithm
boost1 = trainfirst(boost1, train_data);
for i=1:(train_iter - 1)
   last_boost1 = boost1;
   boost1 = trainagain(boost1);
end


% Train our copy of the boosting algorithm
[iterations, weaklearners, my_classifier_weights, my_sample_weights, ...
 training_results, training_errors] = ...
      iterate(iterations, weaklearners, my_classifier_weights, ... 
	      my_sample_weights, training_results, ...
	      training_errors, train_iter, wl);

object_b = classifier_weights(boost1)
other_b = my_classifier_weights

object_w = sample_weights(boost1)'
other_w = my_sample_weights'




% Now come up with a plot of cost function vs alpha for the last
% iteration

short_weights = my_classifier_weights(1, 1:length(my_classifier_weights)-1);
sum_short_weights = sum(short_weights);
max_short_weights = max(short_weights);

all_alpha = linspace(0, max_short_weights * 2);

for i=1:length(all_alpha)
   alpha = all_alpha(i);
   these_weights = [short_weights alpha];
   all_c(i) = cost_functional(these_weights, training_results);
end


figure(1);  clf;  plot(all_alpha, log10(all_c));

min_loc = find(all_c == min(all_c));
calculated_bt = my_classifier_weights(length(my_classifier_weights))
graph_bt = all_alpha(min_loc)
training_error = training_errors(length(training_errors));

hold on;  plot(graph_bt, log10(min(all_c)), 'ro');




% Try the same graph, but calculating it a different way
% (See page 98 of my notebook for more details)

% Find "f" (the new weak learner instance to add)
f = wl_instance(boost1, train_iter)

%figure(3);  clf;  dataplot(train_data);  hold on;
%plotboundary(f, [1 1; 0 0]);

%figure(4);  weight_density_plot(last_boost1);


% Find how "f" classifies our training data
f_y = classify(f, train_x)*2 - 1


% Separate into those which it got right and those that are wrong
right_samples = find(f_y == train_y);
wrong_samples = find(f_y ~= train_y);


% Find the margins of "F" (lastboost)
sample_margins = train_y .* margins(last_boost1, train_x);


% Separate these into right and wrong margins
right_margins = sample_margins(right_samples);
wrong_margins = sample_margins(wrong_samples);


% Calculate the right and wrong costs
right_costs = cost_function(right_margins);
wrong_costs = cost_function(wrong_margins);

sum_right_costs = sum(right_costs)
sum_wrong_costs = sum(wrong_costs)


% Draw a graph
short_weights = abs(classifier_weights(last_boost1));
sum_short_weights = sum(short_weights);
max_short_weights = max(short_weights);

all_alpha = linspace(0, max_short_weights * 2);

all_c = exp(-all_alpha) .* sum_right_costs ...
	+ exp(all_alpha) .* sum_wrong_costs;


figure(2);  clf;  plot(all_alpha, log10(all_c));

min_loc = find(all_c == min(all_c));
graph_bt = all_alpha(min_loc)

hold on;  plot(graph_bt, log10(min(all_c)), 'ro');


% Calculate it yet another way!

% Find "f" (the new weak learner instance to add)
f = wl_instance(boost1, train_iter);
F = last_boost1;

% Draw a graph
short_weights = abs(classifier_weights(last_boost1));
sum_short_weights = sum(short_weights);
max_short_weights = max(short_weights);

all_alpha = linspace(0, max_short_weights * 2);

for i=1:length(all_alpha)
   alpha = all_alpha(i);
   all_c(i) = sum(sample_cost(train_x, train_y, F, f, alpha));
end
   

figure(3);  clf;  plot(all_alpha, log10(all_c));

min_loc = find(all_c == min(all_c));
graph_bt = all_alpha(min_loc)

hold on;  plot(graph_bt, log10(min(all_c)), 'ro');


   




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ...
      [iterations_o, weaklearners_o, classifier_weights_o, ...
       sample_weights_o, training_results_o, training_errors_o] = ...
      iterate(iterations, weaklearners, classifier_weights, sample_weights, ...
	      training_results, training_errors, num_iter, wl)

% ITERATE perform the specified number of iterations of boosting

global train_x train_y train_data

for i=1:num_iter
   % STEP 1: train our weaklearner
   new_weaklearner = train(wl, train_x, (1+train_y)./2, sample_weights);

   if (isempty(weaklearners))
      weaklearners = new_weaklearner;
   else
      weaklearners(iterations+1) = new_weaklearner;
   end
   
   train_error = training_error(new_weaklearner);
   training_errors = [training_errors train_error];

   % Save how this weaklearner classifies our samples
   new_y = classify(new_weaklearner, train_x)*2 - 1;
   training_results(iterations+1, :) = new_y';
   
   % STEP 2: check for termination conditions
   if (train_error >= 0.5)
      error('Training error exceeded 0.5!');
   end
   
   if (train_error == 0)
      error('Training error of zero!');
   end
   
%    figure(4);  clf;  subplot(1, 2, 1);
%    dataplot(train_data);
%    hold on;
%    plotboundary(new_weaklearner, [1 1; 0 0]);
   
%    subplot(1, 2, 2);
%    density_plot(2, train_x, (train_y+1)/2, sample_weights);
   
   % STEP 3: calculate classifier weight value
   bt = - log(train_error / (1 - train_error));
   classifier_weights(iterations+1) = bt;
   
   % STEP 4: update our sample weights
   sample_weights = sample_weights .* exp(-bt .* (new_y == train_y));
   sample_weights = sample_weights ./ sum(sample_weights);
   
   iterations = iterations + 1;
end

iterations_o = iterations;
weaklearners_o = weaklearners;
classifier_weights_o = classifier_weights;
sample_weights_o = sample_weights;
training_results_o = training_results;
training_errors_o = training_errors;








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C = cost_functional(classifier_weights, training_results)

% COST_FUNCTIONAL calculate our cost function for the given boosting
% algorithm and training data.

% Formula:
% C = \sum_{i=1}^{m} c(y_i * [b_1 f_1(x_i) + ... + b_n f_n(x_i)])

global train_x train_y

cost = zeros(1, length(train_y));

for i=1:length(train_y)
   % Iterate over the training samples
   margin = sum(training_results(:, i) .* classifier_weights');
   cost(i) = cost_function(train_y(i) * margin);
end

C = sum(cost);

   
   






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = cost_function(x)

% COST_FUNCTION calculate our cost function for the given value of x

c = exp(-x);







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sc = sample_cost(x, y, F, f, alpha)

% Calculates
%
% c(-y [ F(x) + alpha f(x) ] )

m = margins(F, x);
c = classify(f, x)*2-1;
sc = cost_function(y .* (m + c .* alpha));
