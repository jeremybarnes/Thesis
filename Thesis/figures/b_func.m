function b_func

global EPSFILENAME

figure(1);  clf;
plot([1 2], [3 4]);

set(1, 'paperposition', [0 0 4 3]);

print(EPSFILENAME, '-f1','-deps2');