function boost_50samples_results

% BOOST_50SAMPLES_RESULTS display all results for 50 iterations of
% boosting

% boost_50samples_results.m
% Jeremy Barnes, 12/10/1999
% $Id$

% Graphs:
% * Test/train curves for all noise values
% * Calculate average performance and save in file

info = get_test_info('boost-50samples');

figure(1);  clf;  setup_figure;

for i=1:length(info.noise)
