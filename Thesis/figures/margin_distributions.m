function margin_distributions

% margin_distributions.m
% Jeremy Barnes, 20/10/1999
% $Id$

% We draw margin distribution plots for the strict and sloppy algorithms
% Note that we need the individual .mat files to be accessible here

global DATA_SAVE_PATH

pvalues = [1 6 11];
noisevalue = 1;

boost_trial = 1;
normboost_trial = 1;
normboost2_trial = 1;



figure(1);  clf;  setup_figure;
subplot(1, 3, 1);  setup_axis;
subplot(1, 3, 2);  setup_axis;
subplot(1, 3, 3);  setup_axis;

figure(2);  clf;  setup_figure;
subplot(1, 3, 1);  setup_axis;
subplot(1, 3, 2);  setup_axis;
subplot(1, 3, 3);  setup_axis;

linestyles = {'k--', 'k-', 'k:'};

draw_graph('boost-50samples-margins', 1, 1, 1, {'k-'}, 1);
draw_graph('normboost-50samples-margins', 1, [1 6 11], 4, linestyles, 2);
draw_graph('normboost2-50samples-margins', 1, [1 6 11], 1, linestyles, 3);




function draw_graph(test, trial, pvalues, noisevalue, linestyles, sp_num)

% Draws a plot

global DATA_SAVE_PATH

for i=1:length(pvalues)
   pvalue = pvalues(i);
   
   filename = [DATA_SAVE_PATH '/' test '/' test '-trial' int2str(trial)...
	       '-pvalue' int2str(pvalue) '-noisevalue' ...
	       int2str(noisevalue) '.mat'];
   
   load(filename, 'end_margins', 'end_weights', 'train_d');
   
   end_margins = end_margins .* (y_values(train_d) .* 2 - 1);
   
   figure(1);
   subplot(1, 3, sp_num);
   plot_margin_distribution(end_margins./sum(end_weights), ...
			    'linestyle', linestyles{i});  hold on;
   
   figure(2);
   subplot(1, 3, sp_num);
   loglog(1:length(end_weights), end_weights, linestyles{i});  hold on;
end





