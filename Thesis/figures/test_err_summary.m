function test_err_summary

% test_err_summary
% Jeremy Barnes, 17/10/1999
% $Id$

global EPSFILENAME

display_meta_summary('error');


set(1, 'paperposition', [0 0 7 3]);

print(EPSFILENAME, '-f1','-deps');