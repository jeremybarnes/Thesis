function p_convex

% p_convex.m
% Jeremy Barnes 27/7/1999
% $Id$


global EPSFILENAME


figure(1);  clf;  setup_figure;  setup_axis;


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
xlabel('\itu');
ylabel('\itv');

text(0.6, 0.9, '\it{p=2}', 'fontname', 'times');
text(0.2, 0.2, '\it{p=1/2}', 'fontname', 'times');
text(0.5, 0.5, '\it{p=1}', 'fontname', 'times');

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1', '-deps2', '-loose');

