function boost_overfitting

% boost_overfitting.m
% Jeremy Barnes, 15/10/1999
% $Id$

global EPSFILENAME

display_results('boost-50samples', 'rows', 1, 'cols', 3, 'title', ['(%l)' ...
		    ' \sl{Noise = %N}'], 'noisevalues', [0 0.1 0.2], ...
		    'y_range', [0 0.5], 'axis_function', 'setup_axis', ...
		    'figure_function', 'setup_figure', ...
		    'test_err_style', 'k-', 'train_err_style', 'k--');

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc', '-loose');

