function slide13

% slide13.m
% Jeremy Barnes, 27/7/19999
% $Id$

% This one simply plots the b function against epsilon_t, raised to 1/p
% for different values of p.

pvalues = [1 0.75 0.5];

epsilon_t = linspace(0.5, 0.99, 50);
b = bfunc(epsilon_t, 0.5);

figure(1);  clf;

for i=1:length(pvalues)
   p = pvalues(i);
   plot(epsilon_t, b.^(1/p));
   hold on;
end

xlabel('epsilon_t');
ylabel('b');
  
axis([0.5 1.0, 0.0 3.0]);

% White background
set(1, 'Color', [1 1 1]);
