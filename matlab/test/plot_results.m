function h = plot_results(test, type, varargin)

% PLOT_RESULTS general routine to draw graphs of test results
%
% SYNTAX:
%
% plot_results('test', 'type', options..._
%
% This function is a general "graph displaying" function.  It extracts
% data from a summary and draws it into the current graph figure and
% axis (thus, to draw multi-graph sequences you need to use
% display_results, which uses this function to do all of the graph
% plotting).
%
% The TEST parameter tells which test to get the results from.  This test
% must have been created using the MAKETEST function, etc, etc.
%
% The TYPE parameter tells the system which type of graph to draw.
% Possible values are:
%
% 'trainerr'  - just a training error curve
% 'testerr'   - just the test error curve
% 'testtrain' - both test and training curves
%
% 'trainerrdev'  - training error with standard deviation on each side
% 'testerrdev'   - test error with standard deviation on each side
% 'testtraindev' - test and training error with standard deviation
%
% 'traincount'   - plot of number of trials that reached each iteration
%
% 'besterrnoise'* - best test error vs noise (fixed p) (scatter)
% 'besterrp'*     - best test error vs p (fixed noise) (scatter)
% 'bestiternoise'*- best test iteration vs noise (fixed p) (scatter)
% 'bestiterp'*    - best test iteration vs p (fixed noise) (scatter)
%
% (* = requires a noise/p value option; see below)
%
% Each of these types accept a certain number of options.  The options
% are specified in 'name', value pairs.  They are
%
% 'smoothma', period:  Smooth the plots using a <period> iteration moving
%                      average. (not for scatter plots).  Period 0 = off.
%
% 'pvalues', set:      Specifies which p value(s) to draw graphs for when
%                      a fixed p is used. (scatter only)
%
% 'noisevalues', set:  Specifies which noise value(s) to draw graphs for
%                      when a fixed noise value is used. (scatter only)
%
% 'comparewith', test: Uses the performance values in 'test' as a
%                      baseline for comparison.  Should be boost as it
%                      doesn't depend upon p.
%
% RETURNS:
%
% H is a list of handles to the plots, one for each plot.

% test/plot_results.m
% Jeremy Barnes, 9/10/1999
% $Id$

opt_smoothma = 0;
opt_pvalues = 0;
opt_noisevalues = 0;
opt_comparewith = 0;

for i=1:length(varargin) ./ 2
   option = varargin{i*2-1};
   value = varargin{i*2};
   
   switch option
      case 'smoothma'
	 opt_smoothma = 1;
      case 'pvalues'
	 opt_pvalues = 1;
      case 'noisevalues'
	 opt_noisevalues = 1;
      case 'comparewith'
	 opt_comparewith = 1
	 comparetest = value
      otherwise,
	 error(['invalid option ' option '.']);
   end
end

global DATA_SAVE_PATH;

if (opt_comparewith)
   % Load in the summary-summary for the test that we are comparing with
   filename = [DATA_SAVE_PATH '/' comparetest '/' comparetest '-sum-sum.mat'];
   load(filename, 'test_info', 'avg_err', 'std_err', 'avg_iter', 'std_iter');
   cmp_info = test_info;
   cmp_avg_err = avg_err;
   cmp_std_err = std_err;
   cmp_avg_iter = avg_iter;
   cmp_std_iter = std_iter;
   cmp_noise = test_info.noise;
end


test_info = get_test_info(test);

figure(1);  clf;

best_err = get_test_results(test, 'best_err');
best_iter = get_test_results(test, 'best_iter');

% row = noise, col = p, d3 = errors

% Make into one big matrix

pvalues = zeros(1, length(test_info.p) .* test_info.trials);

err_results = zeros(length(test_info.noise), ...
		    length(test_info.p) .* test_info.trials);
iter_results = zeros(length(test_info.noise), ...
		     length(test_info.p) .* test_info.trials);

err_means = zeros(length(test_info.noise), length(test_info.p));
err_stdevs = zeros(length(test_info.noise), length(test_info.p));

iter_means = zeros(length(test_info.noise), length(test_info.p));
iter_stdevs = zeros(length(test_info.noise), length(test_info.p));

for i=1:length(test_info.noise)
   
   this_part_err = best_err(i, :, :);
   this_part_iter = best_iter(i, :, :);
   
   these_p_results = [];
   these_err_results = [];
   these_iter_results = [];
   
   for j=1:length(test_info.p)
      
      err_means(i, j) = mean(this_part_err(1, j, :), 3);
      err_stdevs(i, j) = std(this_part_err(1, j, :), 3);
      
      iter_means(i, j) = mean(this_part_iter(1, j, :), 3);
      iter_stdevs(i, j) = std(this_part_iter(1, j, :), 3);
      
      these_p_results = [these_p_results ...
			 ones(1, test_info.trials) .* test_info.p(j)];
      these_err_results = [these_err_results ...
		    permute(this_part_err(1, j, :), [1 3 2])];
      these_iter_results = [these_iter_results ...
		    permute(this_part_iter(1, j, :), [1 3 2])];
   end
   
   err_results(i, :) = these_err_results;
   iter_results(i, :) = these_iter_results;
   pvalues = these_p_results;
end


% Draw graphs

fignum = 1;
figure(1);  clf;

% Graphs of p vs best error
for i=1:length(test_info.noise)
   subplot(length(test_info.noise), 2, i*2-1);
   plot(pvalues, err_results(i, :), 'rx');  hold on;
   plot(test_info.p, err_means(i, :), 'b-');
   plot(test_info.p, err_means(i, :) + err_stdevs(i, :), 'b:');
   plot(test_info.p, max(err_means(i, :) - err_stdevs(i, :), 0), 'b:');
   
   if (opt_comparewith)
      % Plot a baseline and limits for the comparewith
      
      % First, find which noise value to use
      n = test_info.noise(i);
      index = find(cmp_noise == n);
      if (~isempty(index))
	 this_avg_err = cmp_avg_err(index);
	 this_std_err = cmp_std_err(index);
	 m = this_avg_err;
	 u = this_avg_err + this_std_err;
	 l = this_avg_err - this_std_err;
	 plot([min(test_info.p) max(test_info.p)], [m m], 'k-', ...
	      'linewidth', 2);
	 plot([min(test_info.p) max(test_info.p)], [u u], 'k:', ...
	      'linewidth', 2);
	 if (l > 0)
	    plot([min(test_info.p) max(test_info.p)], [l l], 'k:', ...
		 'linewidth', 2);
	 end
      end
   end
   
%   title(['Noise = ' num2str(test_info.noise(i))]);
%   xlabel('p');
%   ylabel('Best test error');
   grid on;
end


% Graphs of p vs best iteration
for i=1:length(test_info.noise)
   subplot(length(test_info.noise), 2, i*2);
   semilogy(pvalues, iter_results(i, :), 'rx');  hold on;
   plot(test_info.p, iter_means(i, :), 'b-');
   plot(test_info.p, iter_means(i, :) + iter_stdevs(i, :), 'b:');
   plot(test_info.p, max(iter_means(i, :) - iter_stdevs(i, :), 0), 'b:');
   
   if (opt_comparewith)
      % Plot a baseline and limits for the comparewith
      
      % First, find which noise value to use
      n = test_info.noise(i);
      index = find(cmp_noise == n);
      if (~isempty(index))
	 this_avg_iter = cmp_avg_iter(index);
	 this_std_iter = cmp_std_iter(index);
	 m = this_avg_iter;
	 u = this_avg_iter + this_std_iter;
	 l = this_avg_iter - this_std_iter;
	 plot([min(test_info.p) max(test_info.p)], [m m], 'k-', ...
	      'linewidth', 2);
	 plot([min(test_info.p) max(test_info.p)], [u u], 'k:', ...
	      'linewidth', 2);
	 if (l > 0)
	    plot([min(test_info.p) max(test_info.p)], [l l], 'k:', ...
		 'linewidth', 2);
	 end
      end
   end
   
%   title(['Noise = ' num2str(test_info.noise(i))]);
%   xlabel('p');
%   ylabel('Best test iteration');
   grid on;
end


% Done


