function slide12

% slide12.m
% Jeremy Barnes, 27/7/1999
% $Id$

% A slide of overfitting in boosting

maxiterations = 1000;
numpoints = 100;
noise = 0.2;

b = category_list('binary');
wl = decision_stump(b, 2);
myboost = p_boost(wl, 1000, 1);

% Generate our training data
d = dataset(b, 2);
d = datagen(d, 'ring', numpoints, 0, noise);
[x, y] = data(d);

figure(1);  clf;  dataplot(d);

% Complete our initial training step
myboost = trainfirst(myboost, d);

displayiter = 500;

iter = 1;
figure(1);
clf;
  

while (iter <= displayiter)
   disp(['Iteration ' num2str(iter)]);

   % plot margins
   if (iter == displayiter)
      figure(1);  clf;
      marginplot(myboost, [1 1; 0 0]);
	   hold on;
	   dataplot(d);
	   plot_decision_boundary(myboost);
      axis([-0.2 1.2 -0.2 1.2 0 2]);
      title([int2str(iter) ' iterations, noise = ' num2str(noise)]);
   end

   % Now continue training
   
   if (~aborted(myboost))
	 	myboost = trainagain(myboost);
   end

   iter = iter + 1;
end

