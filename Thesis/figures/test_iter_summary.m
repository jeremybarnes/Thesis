function test_iter_summary

% test_iter_summary
% Jeremy Barnes, 17/10/1999
% $Id$

global EPSFILENAME

display_meta_summary('iter');


set(1, 'paperposition', [0 0 7 3]);

print(EPSFILENAME, '-f1','-depsc2', '-adobecset');