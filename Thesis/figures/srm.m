function srm

% srm.m
% Jeremy Barnes, 29/9/1999
% $Id$

global EPSFILENAME
global DATA_SAVE_PATH;

figure(1);  clf;  setup_figure;  setup_axis;

if (isempty(DATA_SAVE_PATH))
   error(['runtest: must set global variable DATA_SAVE_PATH before you' ...
	  ' begin']);
end

% Summary file name
summaryfile = [DATA_SAVE_PATH '/boostonly-100samples-summary.mat'];

% Load in our summary
load_error = 0;
eval('load(summaryfile);', 'load_error = 1;');

if (load_error)
   error('Could not load summary file.  Create it with summarise.');
end

% The final form of the summary is a 3-dimensional array.  The first
% dimension is the noise values.  The second dimension is the p values.
% The third dimension is the iteration numbers.

% We also keep a second array that contains the number of values that
% have been added together in the first array.  This is necessary as
% training may abort, meaning that more make it to lower
% iterations than to higher iterations.

num_p_values = length(p);
num_noise_values = length(noise);

% The counter variables
currentfig = 1;

noisevalue = find(noise == 0.2);
pvalue = 1;
train_d = train_res(noisevalue, pvalue, :);
test_d = test_res(noisevalue, pvalue, :);

noise = 0.2;

iter = 1:length(test_d);
semilogx(iter, test_d, 'k-');  hold on;

iter = 1:length(train_d);
semilogx(iter, train_d, 'k:');

xlabel('Iteration \it{t}');
ylabel('Risk');

optimal_i = find(test_d == min(test_d));
optimal_e = test_d(optimal_i);

plot(optimal_i, optimal_e, 'ko', 'markersize', 10);
plot([1 optimal_i], [optimal_e, optimal_e], 'k-.');
plot([optimal_i optimal_i], [0 optimal_e], 'k-.');

text(300, 0.3, '\it{R_{\rm{test}}}', 'fontname', 'times');
text(100, 0.1, '\it{R_{\rm{emp}}}', 'fontname', 'times');

get(gca)


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');

