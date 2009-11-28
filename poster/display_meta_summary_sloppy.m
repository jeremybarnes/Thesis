function display_meta_summary_sloppy(graph, varargin)

% DISPLAY_META_SUMMARY draw graphs from the meta_summary info

% display_meta_summary.m
% Jeremy Barnes, 17/10/1999
% $Id: display_meta_summary.m,v 1.3 1999/10/24 22:37:18 jeremy Exp $


global DATA_SAVE_PATH;

if (isempty(DATA_SAVE_PATH))
   error('You must set the global variable DATA_SAVE_PATH first');
end

filename = [DATA_SAVE_PATH '/meta-summary.mat'];
load(filename, 'baseline_results', 'test_results', 'baselines', ...
     'tests', 'test_names', 'dataset_names');

if (nargin == 0)
   graph = 'error';
end

numdatasets = length(baselines)
s = size(tests);
numalgorithms = 1;

switch graph
   case 'error'
      % Graph 1: AdaBoost average error vs. average error at optimal p
      % Algorithms identified by colours, datasets by symbols

      datamarkers = {{'.', 'x', 'o', '*'}, {'s'}, {'^'}, {'d'}};

      figure(1);  clf;
      
      for i=2:2
	 subplot(1, 1, 1);
	 
	 for j=1:numdatasets
	    baseline = baseline_results{j};
	    alg_results = test_results{j, i};
	    if (~isempty(alg_results))
	       means = alg_results.err_means;
	       stdevs = alg_results.err_stdevs;
	       s = size(means);
	       numnoisevalues = s(1);
	       for k=1:numnoisevalues
		  best_index = find(means(k, :) == min(means(k, :)));
		  best_index = best_index(1);
		  
		  best_mean = means(k, best_index);
		  best_stdev = stdevs(k, best_index);
		  
		  baseline_mean = baseline.avg_err(k);
		  baseline_stdev = baseline.std_err(k);
		  
		  hold on;
		  
		  % Plot error bars
		  x = best_mean;  y = baseline_mean;
		  xl = best_mean - best_stdev;
		  xr = best_mean + best_stdev;
		  yl = baseline_mean - baseline_stdev;
		  yu = baseline_mean + baseline_stdev;
		  
		  errorbar_style = {'linewidth', 0.5, ...
				    'color', [0.5 0.5 0.5]};
		  plot([x xl], [y y], errorbar_style{:});
		  plot([x xr], [y y], errorbar_style{:});
		  plot([x x], [y yl], errorbar_style{:});
		  plot([x x], [y yu], errorbar_style{:});
		  
		  if (datamarkers{j}{k} == '.')
		     style = {['k' datamarkers{j}{k}], ...
			      'MarkerFaceColor', [1 1 1], ...
			      'MarkerSize', 15};
		  else
		     style = {['k' datamarkers{j}{k}], ...
			      'MarkerFaceColor', ...
			      [1 1 1]};
		  end
		  
		  plot(best_mean, baseline_mean, style{:});
	       end
	    end
	 end
	 plot([0 0.4], [0 0.4], 'k-');
	 xlabel('Test error');
	 ylabel('AdaBoost');
	 axis square;
      end
      
   case 'iter'
      % Graph 2: AdaBoost average error vs. average error at optimal p
      % Algorithms identified by colours, datasets by symbols

      algcolors = {'r', 'b', 'k'};
      
      datamarkers = {{'.', 'x', 'o', '*'}, {'s'}, {'^'}, {'d'}};

      figure(1);  clf;  setup_figure;
      
      for i=1:numalgorithms
	 subplot(1, numalgorithms, i);  setup_axis;
	 
	 algcolor = algcolors{i};
	 for j=1:numdatasets
	    baseline = baseline_results{j};
	    alg_results = test_results{j, i};
	    if (~isempty(alg_results))
	       err_means = alg_results.err_means;
	       means = alg_results.iter_means;
	       stdevs = alg_results.iter_stdevs;
	       s = size(means);
	       numnoisevalues = s(1);
	       for k=1:numnoisevalues
		  best_index = find(err_means(k, :) == min(err_means(k, :)));
		  best_index = best_index(1);
		  
		  best_mean = means(k, best_index);
		  best_stdev = stdevs(k, best_index);
		  
		  baseline_mean = baseline.avg_iter(k);
		  baseline_stdev = baseline.std_iter(k);
		  
		  % Plot error bars
		  x = best_mean;  y = baseline_mean;
		  xl = max(0.01, best_mean - best_stdev);
		  xr = best_mean + best_stdev;
		  yl = max(0.01, baseline_mean - baseline_stdev);
		  yu = baseline_mean + baseline_stdev;
		  
		  errorbar_style = {'linewidth', 0.5, ...
				    'color', [0.5 0.5 0.5]};
		  loglog([x xl], [y y], errorbar_style{:});  hold on;
		  loglog([x xr], [y y], errorbar_style{:});
		  loglog([x x], [y yl], errorbar_style{:});
		  loglog([x x], [y yu], errorbar_style{:});

		  if (datamarkers{j}{k} == '.')
		     style = {['k' datamarkers{j}{k}], ...
			      'MarkerFaceColor', [1 1 1], ...
			      'MarkerSize', 15};
		  else
		     style = {['k' datamarkers{j}{k}], ...
			      'MarkerFaceColor', ...
			      [1 1 1]};
		  end

		  loglog(best_mean, baseline_mean, style{:});
	       end
	    end
	 end
	 plot([1 1000], [1 1000], 'k-');
	 axis([1 1000 1 1000]);
	 xlabel('Iterations');
	 ylabel('AdaBoost');
	 title(['(' i+96 ') \sl{' test_names{i+1} '}']);
	 axis square;
      end

   case 'perror'
      figure(1);  clf;  setup_figure;
      
      plot_map = [1 5 6 7];

      algmarkers = {'-', '-.', ':'};
      
      pvalues = 0.5:0.1:2.0;
      minp = min(pvalues);
      maxp = max(pvalues);
      
      for i=1:numalgorithms
      
	 for j=1:numdatasets
	    baseline = baseline_results{j};
	    alg_results = test_results{j, i};
	    if (~isempty(alg_results))
	       means = alg_results.err_means;
	       stdevs = alg_results.err_stdevs;
	       s = size(means);
	       numnoisevalues = s(1);
	       for k=1:numnoisevalues
		  subplot(4, 2, plot_map(j)+k-1);  setup_axis;
		  
		  this_mean = means(k, :);
		  
		  best_index = find(means(k, :) == min(means(k, :)));
		  best_index = best_index(1);
		  
		  best_mean = means(k, best_index);
		  best_stdev = stdevs(k, best_index);
		  
		  baseline_mean = baseline.avg_err(k);
		  baseline_stdev = baseline.std_err(k);
		  
		  style = ['k' algmarkers{i}];

		  plot(pvalues, this_mean, style);  hold on;
		  plot(pvalues(best_index), best_mean, 'k.', 'markersize', ...
		       10);
		  plot([minp maxp], [baseline_mean baseline_mean], ...
		       'k-', 'linewidth', 2);
	       end
	    end
	 end
      end

      graphtitles = {'ring0', 'ring10', 'ring20', 'ring30', 'sonar', ...
		     'wpbc', 'acacia'};
      for i=1:7
	 subplot(4, 2, i);
	 axis tight;
	 ax = axis;
	 ax
	 text(1.5, ax(4) - 0.1 * (ax(4)-ax(3)), graphtitles{i});
      end
      
      subplot(4, 2, 7);  xlabel('\it{p}');
      subplot(4, 2, 6);  xlabel('\it{p}');
      
      for i=1:2:7
	 subplot(4, 2, i);
	 ylabel('Test error');
      end
      
end
