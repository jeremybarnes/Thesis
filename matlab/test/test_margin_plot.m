function test_margin_plot

% TEST_MARGIN_PLOT test the margin_plot function

% test_margin_plot.m
% Jeremy Barnes, 20/5/1999
% $Id$

b = category_list('binary');
d = dataset(b, 2);
data = datagen(d, 'ring', 200, 0, 0);

c = decision_stump(b, 2);

b1 = boost(c, 100);
b1 = trainfirst(b1, data);

for i=1:50
   figure(1);  clf;
   marginplot(b1, [0 0; 1 1]);
   hold on;
   dataplot(data);

   b1 = trainagain(b1);
   pause;
end

