function slide6

% slide6.m
% Jeremy Barnes, 26/7/1999
% $Id$

% A slide of the margin surface of a decision stump (done by doing just one
% iteration of boosting).

maxiterations = 1000;
numpoints = 20;

wl = decision_stump(2, 2);
myboost = p_boost(wl, 1);

% Generate our training and test data
d = dataset(2, 2);
d = datagen(d, 'ring', numpoints, 0, 0);
[x, y] = data(d);

figure(1);  clf;  dataplot(d);

% Complete our initial training step
myboost = trainfirst(myboost, d);

% Plot it up
figure(1);  clf;
marginplot(myboost, [1 1; 0 0]);  hold on;
dataplot(d);

xlabel('x1');
ylabel('x2');
zlabel('margin');

% White background
set(1, 'Color', [1 1 1]);

