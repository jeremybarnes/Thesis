function sample_weights

% slide10.m
% Jeremy Barnes, 27/7/1999
% $Id$

% Slide of weight densities after a certain number of iterations


global EPSFILENAME

maxiterations = 1000;
numpoints = 50;

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

displayrows = 1;
displaycols = 2;
displayiters = [5 100];
whichplot = 1;

iter = 1;
figure(1);
clf;

r = sqrt(0.125);
theta = linspace(0, 2*pi);
x = 0.5 + r * cos(theta);
y = 0.5 + r * sin(theta);


while (iter <= displayiters(length(displayiters)))
   disp(['Iteration ' num2str(iter)]);

   % plot weight density
   if (ismember(iter, displayiters))
      subplot(displayrows, displaycols, whichplot);
      weight_density_plot(myboost, 'markercolor');  hold on;
      plot(x, y, 'k--');
      axis([0 1 0 1]);
      title([int2str(iter) ' iterations']);
      axis square;
      whichplot = whichplot + 1;
   end

   % Now continue training
   
   if (~aborted(myboost))
	 	myboost = trainagain(myboost);
   end

   iter = iter + 1;
end

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');
