function training_curves_strict

% training_curves_strict.m
% Jeremy Barnes, 19/10/1999
% $Id$

global EPSFILENAME

display_results('normboost-50samples', 'testtrain', ...
		'rows', 1, ...
		'cols', 3, ...
		'title', '(%l) \sl{Noise = %N}', ...
		'noisevalues', 0.3, ...
		'pvalues', [0.5 1.0 1.5], ...
		'y_range', [0 0.5], ...
		'axis_function', 'setup_axis', ...
		'figure_function', 'setup_figure', ...
		'test_err_style', 'k-', ...
		'train_err_style', 'k:', ...
		'squareaxis', 1);

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps2');

