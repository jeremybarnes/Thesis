function newc = profile_cart_train(datatype, numpoints, cost_fn, maxdepth)

% PROFILE_CART_TRAIN profile the training of the CART classifier
%
% SYNTAX:
%
% profile_cart_train('datatype', numpoints, 'cost_fn', maxdepth)
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

% profile_cart_train.m
% Jeremy Barnes, 17/5/1999
% $Id$

binary = category_list('binary');
d = dataset(binary, 2);

train_data = datagen(d, datatype, numpoints, 0, 0);
test_data  = datagen(d, datatype, numpoints, 0, 0);

c = cart(binary, 2, cost_fn, maxdepth);

numiter = 10;

t1 = cputime;

for i=1:numiter
   newc = train(c, train_data);
end

t2 = cputime;

elapsed_time = (t2 - t1) / numiter

figure(1);
clf;

plottree(newc, [1 1; 0 0]);

train_error = training_error(newc)
class_error = classification_error(newc, test_data)
