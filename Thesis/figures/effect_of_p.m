function effect_of_p

% effect_of_p.m
% Jeremy Barnes, 17/10/1999
% $Id$

global EPSFILENAME

display_meta_summary('perror');


set(1, 'paperposition', [0 0 7 9]);

print(EPSFILENAME, '-f1','-deps');