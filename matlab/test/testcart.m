function testcart(datatype, numpoints, cost_fn, maxdepth)

% TESTCART test out the CART classifier

% testcart.m
% Jeremy Barnes, 6/4/1999
% $Id$

binary = category_list('binary');
d = dataset(binary, 2);
data = datagen(d, datatype, numpoints, 0, 0);

c = cart(binary, 2, cost_fn, maxdepth);

newc = train(c, data);
printtree(newc);

figure(1);
clf;

dataplot(data)
plottree(newc, [1 1; 0 0]);
