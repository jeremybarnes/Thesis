function best_margins(test, noisevalue, pvalue, trial)

% BEST_MARGINS draw a plot of the best margins

% best_margins.m
% Jeremy Barnes, 19/10/1999
% $Id$

global DATA_SAVE_PATH;

if (isempty(DATA_SAVE_PATH))
   error(['runtest: must set global variable DATA_SAVE_PATH before you' ...
	  ' begin']);
end

% Test file name
testfile = [DATA_SAVE_PATH '/' test '/' test '.mat'];

% Load in our test
load_error = 0;
eval('load(testfile);', 'load_error = 1;');

if (load_error)
   error('Could not load test file.  Create it with maketest.');
end

num_p_values = length(p);
num_noise_values = length(noise);

% These arrays hold our information on the best test error and on which
% iteration it occurred.
best_test_error = zeros(num_noise_values, num_p_values, trials);
best_test_iter  = best_test_error;

% The counter variables
trial = 1;
pvalue = 1;
noisevalue = 1;

disp('Collating results...');

% Go through and load all of our files

for noisevalue=1:num_noise_values
   for pvalue=1:num_p_values

      this_test_res = zeros(0, numiterations);
      this_train_res = zeros(0, numiterations);

      for trial=1:trials
	 
	 disp(['Trial ' int2str(trial) ' p=' num2str(p(pvalue)) ...
	       ' noise=' num2str(noise(noisevalue))]);
	 
	 % Save the results
	 load_filename = [DATA_SAVE_PATH '/' test '/' test '-trial' ...
			  int2str(trial) '-pvalue' int2str(pvalue) ...
			  '-noisevalue' int2str(noisevalue)];
	 
	 load(load_filename, 'teste', 'traine');
	 
	 % We store it in a matrix.  The rows correspond to trials;
         % the columns are iteration numbers.  Where the full
         % number of iterations was not performed, it is marked
         % with a "-1" to indicate this fact.  These are then
         % stripped out before means and standard deviations are
         % calculated, in order to avoid skewing the results.
	 
	 it = length(teste);
	 padding = -ones(1, numiterations-it);
	 
	 this_test_res = [this_test_res; teste padding];
	 this_train_res = [this_train_res; traine padding];
	 
	 % Now find where the best test error occurred and its value, and
         % store these away also
	 if (it > 0)
	    bte = min(teste);
	    index = find(teste == bte);
	    if (length(index) > 1)
	       index = index(1);
	    end
	 
	 else % Training was aborted on first iteration
	    bte = NaN;
	    index = -1;
	 end
	 
	 best_test_error(noisevalue, pvalue, trial) = bte;
	 best_test_iter(noisevalue, pvalue, trial) = index;
      end
      
      % For each iteration of this_test_res and this_train_res, we
      % calculate a mean and a standard devitaion

      disp('Calculating statistics...');
      
      for i=1:numiterations
	 % Calculate test statistics
	 this_test = this_test_res(:, i);
	 this_test = this_test(find(this_test >= 0)); % strip out -1s
	 if (~isempty(this_test))
	    this_test_mean(i) = mean(this_test);
	    this_test_std(i)  = std (this_test);
	 else
	    this_test_mean(i) = -1;
	    this_test_std(i) = -1;
	 end
	 
	 % Calculate test statistics
	 this_train = this_train_res(:, i);
	 this_train = this_train(find(this_train >= 0)); % strip out -1s
	 if (~isempty(this_train))
	    this_train_mean(i) = mean(this_train);
	    this_train_std(i)  = std (this_train);
	 else
	    this_train_mean(i) = -1;
	    this_train_std(i) = -1;
	 end
	 
	 % Number of trials that made it through this many iterations
	 this_counts(i) = length(this_test);
      end

      
      % plot for debugging
      %figure(1);  clf;
      %iter = 1:numiterations;
      %semilogx(iter, this_test_mean, 'r-');  hold on;
      %semilogx(iter, this_test_mean+this_test_std, 'r:');
      %semilogx(iter, max(this_test_mean-this_test_std, 0), 'r:');

      %semilogx(iter, this_train_mean, 'b-');
      %semilogx(iter, this_train_mean+this_train_std, 'b:');
      %semilogx(iter, max(this_train_mean-this_train_std, 0), 'b:');
      
      %grid on;
      %figure(2);  clf;

      %semilogx(iter, this_counts, 'k-');
      %pause;
      
      % Store these where they belong
      test_mean(noisevalue, pvalue, :) = this_test_mean;
      test_std (noisevalue, pvalue, :) = this_test_std;
      train_mean(noisevalue, pvalue, :) = this_train_mean;
      train_std (noisevalue, pvalue, :) = this_train_std;
      count_res(noisevalue, pvalue, :) = this_counts;
   end
end

disp('Saving...');

% Save the file
savefile = [DATA_SAVE_PATH '/' test '/' test '-summary.mat'];

save(savefile, 'test_mean', 'test_std', 'train_mean', 'train_std', ...
     'count_res', 'name', 'algorithm', 'p', 'dist', 'samples', ...
     'noise', 'numiterations', 'trials', 'best_test_error', 'best_test_iter');

% Finished!
 
