function runtest(test)

% RUNTEST run a test on a boosting algorithm
%
% SYNTAX:
%
% runtest('test')
%
% This function runs the test specified in 'test'.  This test must have
% first been created using the maketest function.
%
% It writes its progress as it goes, which should allow it to continue
% without too much loss of work if it gets interrupted.
%
% It draws and updates a graph as it goes of its progress.
%
% Use displaytest to display the results of a test.

% runtest.m
% Jeremy Barnes, 23/9/1999
% $Id$

global DATA_SAVE_PATH;

if (isempty(DATA_SAVE_PATH))
   error(['runtest: must set global variable DATA_SAVE_PATH before you' ...
	  ' begin']);
end

% Test file name
testfile = [DATA_SAVE_PATH '/' test '.mat'];
progfile = [DATA_SAVE_PATH '/' test '-progress.mat'];

% Load in our test
load_error = 0;
eval('load(testfile);', 'load_error = 1;');

if (load_error)
   error('Could not load test file.  Create it with maketest.');
end

trial = 1;
pvalue = 1;
noisevalue = 1;

% Load in our progress
eval('load(progfile)', '');


while (trial <= trials)
   
   while (pvalue <= length(p))
      
      while (noisevalue <= length(noise))
	 
	 save(progfile, 'trial', 'pvalue', 'noisevalue');
	 
	 disp(['Trial ' int2str(trial) ' p=' num2str(p(pvalue)) ...
	       ' noise=' num2str(noise(noisevalue))]);
	 
	 % Create our datasets
	 d = dataset;
	 train_d = datagen(d, dist, samples, 0, noise(noisevalue));
	 test_d = datagen(d, dist, 5000, 0, 0);
	 
	 % Create our weaklearner and boosting algorithm
	 wl = decision_stump(category_list('binary'), 2);
	 switch algorithm
	    case 'boost'
	       alg = boost(wl);
	    case 'normboost'
	       alg = normboost(wl, p(pvalue));
	    case 'normboost2'
	       alg = normboost2(wl, p(pvalue));
	    otherwise,
	       error('Invalid algorithm name');
	 end
	 
	 % Test the sucker
	 [train_alg, teste, traine] = ...
	     test(alg, train_d, test_d, numiterations);

	 % Save the results
	 save_filename = [DATA_SAVE_PATH '/' test '-trial' int2str(trial) ...
			  '-pvalue' int2str(pvalue) '-noisevalue' ...
			  int2str(noisevalue)];
	 
	 save(save_filename, 'train_d', 'test_d', 'train_alg', 'teste', ...
	      'traine');
	 
	 noisevalue = noisevalue + 1;
      end
      
      noisevalue = 1;
      pvalue = pvalue + 1;
      
   end
   
   pvalue = 1;
   trial = trial + 1;
end
