function follow_boost

% follow_boost.m
% Jeremy Barnes, 6/8/1999
% $Id$

% Parameters
samples = 50;
distribution = 'ring';
noise = 0.2;
p = 1.0;

% Weaklearner
binary = category_list('binary');
wl = decision_stump(binary, 2);

% Dataset
train_data = dataset(binary, 2);
train_data = datagen(train_data, distribution, samples, 0, noise);
x = x_values(train_data);
y = y_values(train_data)*2 - 1;

% Set up our boosting parameters
iterations = 0;
weaklearners = [];
classifier_weights = [];  % AKA b
sample_weights = ones(size(y)) ./ length(y);

training_errors = [];

figure(1);  clf;

while(1)
   iterations = iterations + 1

   % STEP 1: train our weaklearner
   new_weaklearner = train(wl, x, (y+1)/2, sample_weights)

   if (isempty(weaklearners))
      weaklearners = new_weaklearner;
   else
      weaklearners(iterations) = new_weaklearner;
   end
   
   train_error = training_error(new_weaklearner)
   training_errors = [training_errors train_error];

   % Save how this weaklearner classifies our samples
   new_y = classify(new_weaklearner, x)*2 - 1;
   
   % STEP 2: check for termination conditions
   if (train_error >= 0.5)
      error('Training error exceeded 0.5!');
   end
   
   if (train_error == 0)
      error('Training error of zero!');
   end
   
   % STEP 3: calculate classifier weight value
   bt = - 0.5 * log(train_error / (1 - train_error))
   classifier_weights(iterations) = bt;


   % Try to do it graphically
   short_weights = classifier_weights(1:iterations-1);
   norm_weights = short_weights ./ pnorm(short_weights, p);
   all_alpha = logspace(-5, 0, 101);

   for i=1:length(all_alpha)
      alpha = all_alpha(i);
      cost = sample_cost(x, y, weaklearners(1:iterations-1), ...
			 (1-alpha^p)^(1/p)*norm_weights, ...
			 new_weaklearner, alpha);
      all_costs(i) = sum(cost);
      end

   draw_cost_graph(all_alpha, all_costs);
			 
   % Compare with the normalised calculated version
   calc_bt = bt ./ sum(classifier_weights)

   
   % STEP 4: update our sample weights
   sample_weights = sample_weights .* exp(-bt .* y .* new_y);
   sample_weights = sample_weights ./ sum(sample_weights);

   pause;


end




function sc = sample_cost(x, y, F, b, f, alpha)

% f is a single weaklearner, F is an array of weaklearners, with weights b

% Calculates
%
% c(-y [ F(x) + alpha f(x) ] )
%
% where
%
% F(x) = b1 f1(x) + b2 f2(x) + ... + bn fn(x)

m = zeros(size(y));

% Work out margin
for i=1:length(F)
   c = classify(F(i), x)*2-1;
   m = m + b(i) * c;
end

% Work out contribution of alpha
c = classify(f, x)*2-1;
sc = cost_function(y .* (m + c .* alpha));

function cf = cost_function(x)
cf = exp(-x);



function draw_cost_graph(all_alpha, all_c)

% Draw a graph, indicating the global minimum

plot(all_alpha, log10(all_c));

min_loc = find(all_c == min(all_c));
graph_bt = all_alpha(min_loc)

hold on;  plot(graph_bt, log10(min(all_c)), 'ro');
xlabel('alpha');  ylabel('log_1_0(cost)');