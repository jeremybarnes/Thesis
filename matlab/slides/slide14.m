function slide14

% slide14.m
% Jeremy Barnes 27/7/1999
% $Id$

figure(1);  clf;


a = linspace(0, 1, 101);

pvalues = [0.5];

markers = {'-', '--', ':', '-.', '-'};

for i=1:length(pvalues)
   p=pvalues(i);
   b = (1 - a.^p).^(1/p);
   
   marker = markers{i};
   
   plot(a, b, marker);
   hold on;
   plot(-a, b, marker);
   plot(a, -b, marker);
   plot(-a, -b, marker);
   
end

plot([0 0], [-1.1 1.1], 'k--');
plot([-1.1 1.1], [0 0], 'k--');

axis([-1.1 1.1 -1.1 1.1]);
axis square;
xlabel('alpha');
ylabel('beta');
