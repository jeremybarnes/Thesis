function [avg_err, std_err, avg_iter, std_iter] = summarise_boost

% SUMMARISE_BOOST summarise boosting results; write them in a mat file

% summarise_boost.m
% Jeremy Barnes, 12/10/1999
% $Id$

tests_to_summarise = {'boost-50samples', 'boost-100samples', 'boost-sonar', ...
		   'boost-acacia'};

global DATA_SAVE_PATH;

for i=1:length(tests_to_summarise)
   test = tests_to_summarise{i};
   
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
   
   % Save it to a file
   filename = [DATA_SAVE_PATH '/' test '/' test '-sum-sum.mat'];
   save(filename, 'test_info', 'avg_err', 'std_err', 'avg_iter', 'std_iter');
end

      
      
   