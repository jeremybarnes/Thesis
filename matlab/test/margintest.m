function margintest

% slide6.m
% Jeremy Barnes, 26/7/1999
% $Id$

% A slide of the margin surface of a decision stump (done by doing just one
% iteration of boosting).

numpoints = 20;

b = category_list('binary');
wl = decision_stump(b, 2);
myboost = boost(wl);

% Generate our training and test data
d = dataset(b, 2);
d = datagen(d, 'ring', numpoints, 0, 0);
[x, y] = data(d);

myboost = trainfirst(myboost, d);

% Plot it up
figure(1);  clf;

data = classify(myboost, x)

marginplot(myboost, [1 1; 0 0]);  hold on;

xlabel('x1');
ylabel('x2');
zlabel('margin');

% White background
set(1, 'Color', [1 1 1]);

