function newc = teststump(datatype, numpoints)

% TESTSTUMP test out the DECISION_STUMP classifier
%
% SYNTAX:
%
% teststump('datatype', numpoints)
%
% This function will generate a dataset, use this dataset to train a
% DECISION_STUMP object, and display the decision space as well as the
% training data in a graphical form.
%
% DATATYPE is passed straight to a DATASET object's DATAGEN method, and
% describes the distribution from which the data is drawn.  Some
% possibilities are 'horiz', 'vert', 'diag', 'ring', '1quarter',
% '4quarter', 'chess2x2', 'chess3x3' and 'chess4x4'.
%
% No noise is added to the data.
%
% NUMPOINTS indicates the number of data points to generate.

% teststump.m
% Jeremy Barnes, 23/4/1999
% $Id$

binary = category_list('binary');
d = dataset(binary, 2);

train_data = datagen(d, datatype, numpoints, 0, 0);
test_data  = datagen(d, datatype, numpoints, 0, 0);

c = decision_stump(binary, 2);

tic; newc = train(c, train_data); toc
newc


figure(1);
clf;

dataplot(train_data);
plottree(newc, [1 1; 0 0]);

x = x_values(test_data);
y = classify(newc, x);

%categorised = addsamples(d, x, y);
%hold on;
%dataplot(categorised, 'g+', 'k*');

train_error = training_error(newc)
class_error = classification_error(newc, test_data)
