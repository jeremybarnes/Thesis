function display_results(test, varargin)

% DISPLAY_RESULTS display collated test results
%
% SYNTAX:
%
% display_results('test', options...)
%
% This function reads in a summary file (generated by SUMMARISE) and
% draws a bunch of graphs of what happened.
%
% TEST is the name of the test to display results for.
%
% OPTIONS will allow various things to be specified, such as which graphs
% to draw... currently, it does SFA.

% summarise.m
% Jeremy Barnes, 23/9/1999
% $Id$

global DATA_SAVE_PATH;

if (isempty(DATA_SAVE_PATH))
   error(['runtest: must set global variable DATA_SAVE_PATH before you' ...
	  ' begin']);
end

% Summary file name
summaryfile = [DATA_SAVE_PATH '/' test '-summary.mat'];

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

num_noise_values
num_p_values
trials

% Go through and load all of our files

for noisevalue=1:num_noise_values
   for pvalue=1:num_p_values
      figure(currentfig);
      currentfig = currentfig + 1;
      
      train_d = train_res(noisevalue, pvalue, :);
      test_d = test_res(noisevalue, pvalue, :);
      graphtitle = ['Training profile: noise=' num2str(noise(noisevalue))];
      draw_training_profile(test_d, train_d, graphtitle, noise(noisevalue));
   end
end


function draw_training_profile(test_d, train_d, graphtitle, noise)

% Draws a graph

clf;

iter = 1:length(test_d);
semilogx(iter, test_d, 'r-');  hold on;

iter = 1:length(train_d);
semilogx(iter, train_d, 'b-');

plot([1 length(train_d)], [noise noise], 'k--');

xlabel('Iterations');
ylabel('Error');

legend('Test error', 'Training error');
title(graphtitle);



