function testcart(datatype, numpoints, cost_fn, maxdepth)

% TESTCART test out the CART classifier
%
% SYNTAX:
%
% testcart('datatype', numpoints, 'cost_fn', maxdepth)
%
% This function will generate a dataset, use this dataset to train a CART
% object, and display the decision space as well as the training data in
% a graphical form.
%
% DATATYPE is passed straight to a DATASET object's DATAGEN method, and
% describes the distribution from which the data is drawn.  Some
% possibilities are 'horiz', 'vert', 'diag', 'ring', '1quarter',
% '4quarter', 'chess2x2', 'chess3x3' and 'chess4x4'.
%
% No noise is added to the data.
%
% NUMPOINTS indicates the number of data points to generate.
%
% COST_FN is passed to the constructor of the CART object, and specifies
% the cost/loss function used to determine the optimal split.  Possible
% values are 'misclassification', 'gini' and 'entropy'.
%
% MAXDEPTH specifies the maximum depth of the tree, not including the
% root node.  This can be used as a method of capacity control
% (especially useful as pruning is not currently implemented).

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
