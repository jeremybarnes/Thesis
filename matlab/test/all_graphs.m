function all_graphs

% all_graphs.m
% Jeremy Barnes, 23/10/1999
% $Id$

global DATA_SAVE_PATH

paperposition = [1 1 7 8];

if (isempty(DATA_SAVE_PATH))
   error('You must set the global variable DATA_SAVE_PATH first');
end

baselines = {'boost-50samples', 'boost-sonar', ...
	     'boost-wpbc-test', 'boost-acacia'};

tests = {'normboost-50samples', 'normboost2-50samples', 'p_boost-50samples';
	 'normboost-sonar2',    'normboost2-sonar2',    'p_boost-sonar';
	 'normboost-wpbc',      'normboost2-wpbc',      '';
	 'normboost-acacia',    'normboost2-acacia',    ''};

test_names = {'AdaBoost', 'Strict', 'Sloppy', 'Naive'};
dataset_names = {{'ring0', 'ring10', 'ring20', 'ring30'},
		 {'sonar'},
		 {'wpbc'},
		 {'acacia'}};

test_names_lc = {'adaboost', 'strict', 'sloppy', 'naive'};



% First step: graphs of the AdaBoost algorithm
plotnum = 1;

figure(1);  clf;  setup_figure;

for i=1:length(baselines)
   test = baselines{i};
   
   test_info = get_test_info(test);
   
   for j=1:length(test_info.noise)

      display_results(test, 'testtrain', ...
		      'noisevalues', test_info.noise(j), ...
		      'display_counts', 1, ...
		      'rows', 4, ...
		      'cols', 2, ...
		      'startplot', plotnum, ...
		      'title', dataset_names{i}{j}, ...
		      'axis_function', 'setup_axis', ...
		      'xlabel', '', ...
		      'ylabel', '', ...
		      'downsample', 250);
      
      plotnum = plotnum + 1;
   end
end

save_graph('boost-summary.eps');


% Step 2 : plot the tests
test_results = cell(size(tests));
s = size(tests);

old_col = 0;
old_row = 0;

for t=1:prod(s)
   col = floor((t-1) ./s(1)) + 1
   row = mod(t-1, s(1)) + 1
      
   test = tests{row, col}

   if (col ~= old_col)
      if (col ~= 1)
	 save_graph([test_names_lc{old_col+1} '-err-summary.eps'], 2);
	 save_graph([test_names_lc{old_col+1} '-iter-summary.eps'], 3);
	 pause;
      end
	 
      
      figure(2);  clf;  setup_figure;  subplot(4, 2, 1);
      setup_axis;

      figure(3);  clf;  setup_figure;  subplot(4, 2, 1);
      setup_axis;

      current_subplot = 1;
   end
   
   old_col = col;
   old_row = row;
   
   if (~isempty(test))
      disp(['Graphing ' test '...']);
   
      test_info = get_test_info(test);
      
      figure(1); clf; setup_figure;
      
      for i=1:length(test_info.noise)
	 
	 figure(1);  clf;
	 display_results(test, 'testtrain', ...
			 'rows', 4, ...
			 'cols', 4, ...
			 'title', 'p = %p', ...
			 'noisevalues', test_info.noise(i), ...
			 'pvalues', 'all', ...
			 'axis_function', 'setup_axis', ...
			 'figure_function', 'setup_figure', ...
			 'test_err_style', 'k-', ...
			 'train_err_style', {'k-', 'color', [0.35 0.35 0.35]}, ...
			 'display_counts', 1, ...
			 'xlabel', '', ...
			 'ylabel', '', ...
			 'downsample', 250);
	 
	 filename = [test_names_lc{col+1} '-' dataset_names{row}{i} '.eps'];
	 save_graph(filename, 1);
      end

      draw_graphs(test, baselines{row}, 4, 2, current_subplot, dataset_names{row});
      
      current_subplot = current_subplot + length(test_info.noise);
   
   end
   
end

save_graph([test_names_lc{old_col+1} '-err-summary.eps'], 2);
save_graph([test_names_lc{old_col+1} '-iter-summary.eps'], 3);
pause;



function save_graph(filename, fignum)

if (nargin == 1)
   fignum = gcf;
end

allfilename = ['/home/jeremy/engn4000/figures/' filename];

disp(['Saving ' allfilename '...']);

set(fignum, 'paperposition', [0 0 8 9]);

print(allfilename, ['-f' int2str(fignum)], '-depsc2', '-adobecset'); 



function draw_graphs(test, comparetest, rows, cols, plotnum, titles)

global DATA_SAVE_PATH;

% Load in the summary-summary for the test that we are comparing with
filename = [DATA_SAVE_PATH '/' comparetest '/' comparetest '-sum-sum.mat'];
load(filename, 'test_info', 'avg_err', 'std_err', 'avg_iter', 'std_iter');
cmp_info = test_info;
cmp_avg_err = avg_err;
cmp_std_err = std_err;
cmp_avg_iter = avg_iter;
cmp_std_iter = std_iter;
cmp_noise = test_info.noise;

test_info = get_test_info(test);

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

% Graphs of p vs best error
for i=1:length(test_info.noise)
   figure(2);
   subplot(rows, cols, plotnum+i-1);
   
   plot(pvalues, err_results(i, :), 'kx', 'color', [0.75 0.75 0.75]);
   hold on;
   plot(test_info.p, err_means(i, :), 'b-');
   plot(test_info.p, err_means(i, :) + err_stdevs(i, :), 'b:');
   plot(test_info.p, max(err_means(i, :) - err_stdevs(i, :), 0), 'b:');
   
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
   
   title(titles{i});
%   title(['Noise = ' num2str(test_info.noise(i))]);
%   xlabel('p');
%   ylabel('Best test error');
   grid on;
end


% Graphs of p vs best iteration
for i=1:length(test_info.noise)
   figure(3);
   subplot(rows, cols, plotnum+i-1);
   
   semilogy(pvalues, iter_results(i, :), 'kx', 'color', [0.75 0.75 0.75]);
   hold on;
   plot(test_info.p, iter_means(i, :), 'b-');
   plot(test_info.p, iter_means(i, :) + iter_stdevs(i, :), 'b:');
   plot(test_info.p, max(iter_means(i, :) - iter_stdevs(i, :), 0), 'b:');
   
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
   
   title(titles{i});
%   title(['Noise = ' num2str(test_info.noise(i))]);
%   xlabel('p');
%   ylabel('Best test iteration');
   grid on;
end



