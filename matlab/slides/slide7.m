function slide7

% slide7.m
% Jeremy Barnes, 26/7/1999
% $Id$

% A slide of the margin surface of a decision stump (done by doing just one
% iteration of boosting).

maxiterations = 1000;
numpoints = 100;

b = category_list('binary');
wl = decision_stump(b, 2);
myboost = p_boost(wl, 1);

% Generate our training data
d = dataset(b, 2);
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

displayrows = 4;
displaycols = 2;
displayiters = [1 2 3 4 8 16 32 64];
whichplot = 1;

iter = 1;
figure(1);
clf;
  

while (iter <= displayiters(length(displayiters)))
   disp(['Iteration ' num2str(iter)]);

   % plot margins
   if (ismember(iter, displayiters))
      subplot(displayrows, displaycols, whichplot);
      marginplot(myboost, [1 1; 0 0]);
	   hold on;
	   dataplot(d);
	   plot_decision_boundary(myboost, [1 1; 0 0]);
      axis([-0.2 1.2 -0.2 1.2 0 2]);
      title([int2str(iter) ' iterations']);
      whichplot = whichplot + 1;
   end

   % Now continue training
   
   if (~aborted(myboost))
	 	myboost = trainagain(myboost);
   end

   iter = iter + 1;
end
