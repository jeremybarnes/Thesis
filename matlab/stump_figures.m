% STUMP_FIGURES produce a series of EPS figures for decision stumps

% stump_figures.m
% Jeremy Barnes, 11/5/1999
% $Id$

b = category_list('binary');
d = dataset(b, 2);

% Figure 1: dataset split on x1

data1 = datagen(d, 'horiz', 10, 0, 0);

figure(1);
clf;
hold on;
dataplot(data1);
plot([0 1], [0.5 0.5], 'k--');
axis([0 1 0 1]);


% Figure 2: dataset split on x2

data2 = 

figure(2);
