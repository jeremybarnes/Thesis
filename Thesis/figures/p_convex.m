function p_convex

% p_convex.m
% Jeremy Barnes 27/7/1999
% $Id$


global EPSFILENAME


figure(1);  clf;


a = linspace(0, 1, 101);

pvalues = [0.5 1 2];

markers = {'--', ':', '-.'};

handles = [];

for i=1:length(pvalues)
   p=pvalues(i);
   b = (1 - a.^p).^(1/p);
   
   marker = ['k' markers{i}];
   
   handles = [handles plot(a, b, marker)]
   hold on;
   plot(-a, b, marker);
   plot(a, -b, marker);
   plot(-a, -b, marker);
   
end

plot([0 0], [-1.1 1.1], 'k-');
plot([-1.1 1.1], [0 0], 'k-');

axis([-1.1 1.1 -1.1 1.1]);
axis square;
xlabel('u');
ylabel('v');

legend(handles, 'p = 0.5', 'p = 1', 'p = 2', -1);


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');
