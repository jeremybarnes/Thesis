function margin_distribution

% margin_distribution.m
% Jeremy Barnes, 17/10/1999
% $Id$

global EPSFILENAME

figure(1);  clf;
text(0, 0, 'Not done yet!');


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps');