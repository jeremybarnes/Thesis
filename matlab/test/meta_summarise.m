function meta_summarise

% META_SUMMARISE summarise all of the summaries
%
% We draw a bunch of graphs

% meta_summarise.m
% Jeremy Barnes, 17/10/1999
% $Id$

global DATA_SAVE_PATH;

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

% First step: summarise the baseline algorithms
disp('Summarising baseline algorithms...');
baseline_results = cell(size(baselines));

for i=1:length(baselines)
   test = baselines{i};
   
   test_info = get_test_info(test);
   
   % Find all best_test_error values
   all_best_test_err  = get_test_results(test, 'best_err',  'all', 'all');
   all_best_test_iter = get_test_results(test, 'best_iter', 'all', 'all');
   
   % Find the average and standard deviation for each type of noise
   for j=1:length(test_info.noise)
      this_err  = all_best_test_err (j, 1, :);
      this_iter = all_best_test_iter(j, 1, :);
      
      avg_err(j) = mean(this_err, 3);
      std_err(j) = std(this_err, 3);
      
      avg_iter(j) = mean(this_iter, 3);
      std_iter(j) = std(this_iter, 3);
   end

   this_alg.test_info = test_info;
   this_alg.avg_err = avg_err;
   this_alg.std_err = std_err;
   this_alg.avg_iter = avg_iter;
   this_alg.std_iter = std_iter;
   
   baseline_results{i} = this_alg;
end


% Step 2 : Summarise the tests
test_results = cell(size(tests));
s = size(tests);
for t=1:prod(s)
   row = floor((t-1) ./s(2)) + 1;
   col = mod(t-1, s(2)) + 1;
      
   test = tests{row, col};
   
   if (~isempty(test))
      disp(['Summarising ' test '...']);
   
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

	    p_errors = permute(this_part_err(1, j, :), [3 1 2]);
	    p_iters  = permute(this_part_iter(1, j, :), [3 1 2]);
	    
	    % Get rid of ones that are NaN (failed on first iteration)
	    not_nan  = find(~isnan(p_errors));
	    non_min1 = find(p_iters >= 0);
	    
	    p_errors = p_errors(not_nan);
	    p_iters  = p_iters (not_nan);
	    
	    err_means(i, j) = mean(p_errors);
	    err_stdevs(i, j) = std(p_errors);
	    
	    iter_means(i, j) = mean(p_iters);
	    iter_stdevs(i, j) = std(p_iters);
	    
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
      
      this_test.err_results = err_results;
      this_test.iter_results = iter_results;
      this_test.pvalues = pvalues;
      
      this_test.err_means = err_means;
      this_test.err_stdevs = err_stdevs;
      this_test.iter_means = iter_means;
      this_test.iter_stdevs = iter_stdevs;
      
      test_results{row, col} = this_test;
   end
end

disp('Saving results...');

filename = [DATA_SAVE_PATH '/meta-summary.mat'];
save(filename, 'baseline_results', 'test_results', 'baselines', ...
     'tests', 'test_names', 'dataset_names');

