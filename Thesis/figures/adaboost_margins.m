function adaboost_margins

% adaboost_margins.m
% Jeremy Barnes, 19/10/1999
% $Id$

global EPSFILENAME

% Set up a classifier that we can train
d = dataset(2, 2);
dtr = datagen(d, 'ring', 100, 0, 0.2);
dts = datagen(d, 'ring', 10, 0, 0);

w = decision_stump(2, 2);

b = boost(w);

% Find out what the values should be
y = y_values(dtr)*2 - 1;


% The iteration numbers that we are interested in...
display_iters = [5 50 1000];
linestyles = {'k-', 'k--', 'k:', 'k:'};

iter_margins = cell(length(display_iters));
iter_weights = cell(length(display_iters));

for i=1:length(display_iters)
   iters = display_iters(i);

   % Use a stupid inefficient method to get at the margins at certain
   % numbers of iterations
   [bout, tre, tse, bw, bm, ew, em] = test(b, dtr, dts, iters, 'nosave');
   
   sumw = sum(classifier_weights(bout));
   iter_weights{i} = sumw;
   
   iter_margins{i} = em.*y./sumw;
end


   


% First subplot: slope of misclassification loss function 
figure(1);  clf;  setup_figure;
subplot(1, 2, 1);  setup_axis;

xvalues = linspace(-1, 1);

for i=1:length(display_iters)
   yvalues = exp(-iter_weights{i}.*xvalues);
   plot(xvalues, yvalues, linestyles{i});  hold on;
   plot([-1 0 0 1], [1 1 0 0], 'k-', 'linewidth', 2);
end

axis([-1 1 0 6]);
xlabel('Margin \it{\gamma}');
ylabel('Cost \it{c(\gamma)}');
axis square;
title('(a) \sl{Cost function approximation}');

% Second subplot: margin distribution after this number of iterations

subplot(1, 2, 2);  setup_axis;

for i=1:length(display_iters)
   plot_margin_distribution(iter_margins{i}, 'linestyle', linestyles{i}, ...
			    'normalise', 1);
   hold on;
end

xlabel('Margin \it{\gamma}');
ylabel('Cumulative density (%)');
set(gca, 'xtick', [0]);
axis square;
title('(b) \sl{Cumulative margin density}');


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps2');

