function noisy1

% NOISY1 perform first bunch of tests on noisy data
%
% SYNTAX:
%
% noisy1
%
% * weaklearner = Decision stumps
%
% * Noise = 0.01, 0.05, 0.1, 0.2
%
% * p = 0.6, 0.8, 1.0
%
% * Datasets "vert" and "diag"
%
% * Samples = 25, 50, 100
%
% * Testing done over 1000 points (test error)
%
% Training runs until obvious overtraining occurs

b = category_list('binary');
weaklearner = decision_stump(b, 2);

noise_values = [0.01 0.05 0.1 0.2];

p_values = [0.6 0.8 1.0];

datasets = {'vert', 'diag'};

sample_values = [25 50 100];

test_points = 1000;

numtests = length(noise_values) * length(p_values) * length(datasets) * ...
    length(sample_values);

testnum = 0;

for i=noise_values
   noise = noise_values(i);
   for j=sample_values
      samples = sample_values(j);
      for k=p_values
	 p = p_values(k);
	 for l=1:length{datasets}
	    testnum = testnum + 1;
	    disp(['test number ' num2str(testnum) ' of ' ...
		  num2str(numtests)]);
	    dataset = datasets{l};
	    run_test(weaklearner, noise, samples, p, datset);
	 end
      end
   end   
end





function run_test(weaklearner, noise, samples, p, dataset)


