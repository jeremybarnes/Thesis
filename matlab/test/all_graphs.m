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
		      'axis_function', 'setup_axis');
      
      plotnum = plotnum + 1;
   end
end

save_graph('boost-summary.eps');


% Step 2 : plot the tests
test_results = cell(size(tests));
s = size(tests);
for t=1:prod(s)
   row = floor((t-1) ./s(2)) + 1;
   col = mod(t-1, s(2)) + 1;
      
   test = tests{row, col};
   
   if (~isempty(test))
      disp(['Graphing ' test '...']);
   
      test_info = get_test_info(test);
      
      figure(1); clf; setup_figure;
      figure(2); clf; setup_figure;
      
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
			 'show_counts', 1, ...
			 'startletter', 'd');
	 
	 filename = [test '-' dataset_names{col}{i} '.eps']
      
	 % Add to the test summary bit
	 figure(2);  
	 
      end
   
      
   
   end
end

disp('Saving results...');

filename = [DATA_SAVE_PATH '/meta-summary.mat'];
save(filename, 'baseline_results', 'test_results', 'baselines', ...
     'tests', 'test_names', 'dataset_names');



function savegraph(filename)

return % for now