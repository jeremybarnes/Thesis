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
% RETURNS:
%
% H is a list of handles to the plots, one for each plot.

% test/plot_results.m
% Jeremy Barnes, 9/10/1999
% $Id$


info = get_test_info(test);

figure(1);  clf;

best_err = get_test_results(test, 'best_err');
best_iter = get_test_results(test, 'best_iter');

% row = noise, col = p, d3 = errors



% Make into one big matrix

pvalues = zeros(1, length(info.p) .* info.trials);
err_results = zeros(length(info.noise), length(info.p) .* info.trials);
iter_results = zeros(length(info.noise), length(info.p) .* info.trials);

for i=1:length(info.noise)
   
   this_part_err = best_err(i, :, :);
   this_part_iter = best_iter(i, :, :);
   
   these_p_results = [];
   these_err_results = [];
   these_iter_results = [];
   
   for j=1:length(info.p)
      
      these_p_results = [these_p_results; ...
			 ones(1, info.trials) .* info.p(j)];
      these_err_results = [these_err_results; ...
		    permute(this_part_err(1, j, :), [1 3 2])];
      these_iter_results = [these_iter_results; ...
		    permute(this_part_iter(1, j, :), [1 3 2])];
   end
   
   err_results(i, :) = these_err_results;
   iter_results(i, :) = these_iter_results;
   pvalues = these_p_results;
end


% Draw graphs

fignum = 1;

% Graphs of p vs best error
for i=1:length(info.noise)
   figure(fignum);  clf;
   plot(pvalues, these_err_results(i, :), 'rx');
   title(['Noise = ' int2str(info.noise)]);
   xlabel('p');
   ylabel('Best test error');
   fignum = fignum + 1;
end


% Graphs of p vs best iteration
for i=1:length(info.noise)
   figure(fignum);  clf;
   plot(pvalues, these_iter_results(i, :), 'rx');
   title(['Noise = ' int2str(info.noise)]);
   xlabel('p');
   ylabel('Best test iteration');
   fignum = fignum + 1;
end


% Done


