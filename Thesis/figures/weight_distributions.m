function weight_distributions

% weight_distributions.m
% Jeremy Barnes, 20/10/1999
% $Id$

% We draw margin distribution plots for the strict and sloppy algorithms
% Note that we need the individual .mat files to be accessible here

global EPSFILENAME

global DATA_SAVE_PATH

pvalues = [1 6 11];
noisevalue = 1;

boost_trial = 1;
normboost_trial = 1;
normboost2_trial = 1;



figure(1);  clf;  setup_figure;

linestyles = {{'k-', 'color', [0.75 0.75 0.75]}, {'k-'}, ...
	      {'k-', 'color', [0.5 0.5 0.5]}};

draw_graph('boost-50samples-margins', 1, 1, 1, {{'k-'}}, 1);
draw_graph('normboost-50samples-margins', 1, [1 6 11], 4, linestyles, 2);
draw_graph('normboost2-50samples-margins', 1, [1 6 11], 1, linestyles, 3);

subplot(2, 3, 1);  setup_axis;  title('(a) \sl{AdaBoost}');
ylabel('Classifier weight');
subplot(2, 3, 2);  setup_axis;  title('(b) \sl{Strict}');
subplot(2, 3, 3);  setup_axis;  title('(c) \sl{Sloppy}');
ax = plotyy([0 1], [1 0], [1 0], [1 0]);

axes(ax(2));  hold on;
get(gca)
draw_graph('normboost2-50samples-margins', 1, [1 6 11], 1, linestyles, 0);
set(ax(2), 'plotboxaspectratiomode', 'manual', ...
	   'yscale', 'log', ...
	   'ylim', [10^-5 10^0], ...
	   'yticklabelmode', 'auto', ...
	   'ytickmode', 'auto', ...
	   'xscale', 'log', ...
	   'xlim', [1 10000], ...
	   'xtick', []);


subplot(2, 3, 4);  setup_axis;  xlabel('Iterations');  title('(d)');
ylabel('Training error');
subplot(2, 3, 5);  setup_axis;  xlabel('Iterations');  title('(e)');
subplot(2, 3, 6);  setup_axis;  xlabel('Iterations');  title('(f)');

set(gcf, 'paperposition', [0 0 7 5]);


print(EPSFILENAME, '-f1','-depsc2', '-adobecset');



function draw_graph(test, trial, pvalues, noisevalue, linestyles, sp_num, ...
		    normalise)

% Draws a plot

global DATA_SAVE_PATH

if (nargin == 6)
   normalise = 0;
end

for i=1:length(pvalues)
   pvalue = pvalues(i);
   
   filename = [DATA_SAVE_PATH '/' test '/' test '-trial' int2str(trial)...
	       '-pvalue' int2str(pvalue) '-noisevalue' ...
	       int2str(noisevalue) '.mat'];
   
   load(filename, 'end_margins', 'end_weights', 'train_d', 'traine');
%   whos('-file', filename)
   
   end_margins = end_margins .* (y_values(train_d) .* 2 - 1);
   
   if (normalise)
      end_weights = end_weights ./ sum(end_weights);
   end
   
   if (sp_num > 0)
      subplot(2, 3, sp_num);
   end
   loglog(1:length(end_weights), end_weights, linestyles{i}{:});
   if (sp_num > 0)
      hold on;  grid on;  axis square;
   end
   
   if (sp_num > 0)
      subplot(2, 3, sp_num+3);  grid on;  axis square;
      semilogx(1:length(traine), traine, linestyles{i}{:});  hold on;
      hold on;  grid on;  axis square;
   end
end


