function plotb()

% plotb.m
% Jeremy Barnes, 5/7/1999
% $Id$

% Plots a graph of the b function against beta, for various values of p.

beta = linspace(0.1,1,91);

figure(1);  clf;  hold on;

styles = {'-', ':', '--'};
pvalues = [0.5 1 2];

for i=1:length(pvalues)
   bp = b(beta, pvalues(i));
   plot(beta, bp, ['b' styles{i}]);
end

legend('p=0.5', 'p=1', 'p=2', 0);

xlabel('beta');
ylabel('b');
title('b against beta, different values of p');


function res = b(beta, p)

res = abs(log(beta));
res = res .^ (1/p);

