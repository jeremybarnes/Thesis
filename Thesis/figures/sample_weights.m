function sample_weights

% sample_weights.m
% Jeremy Barnes, 27/7/1999
% $Id$

% diagram of weight densities after a certain number of iterations


global EPSFILENAME

maxiterations = 1000;
numpoints = 50;

wl = decision_stump(2, 2);
myboost = p_boost(wl, 1);

% Generate our training data
d = dataset(2, 2);
d = datagen(d, 'ring', numpoints, 0, 0);
[x, y] = data(d);

% Complete our initial training step
myboost = trainfirst(myboost, d);

% Plot it up

displayrows = 1;
displaycols = 2;
displayiters = [5 100];
whichplot = 1;

iter = 1;
figure(1);
clf;  setup_figure;

r = sqrt(0.125);
theta = linspace(0, 2*pi);
x = 0.5 + r * cos(theta);
y = 0.5 + r * sin(theta);

starttext = {'(a) ', '(b) '};

while (iter <= displayiters(length(displayiters)))
   disp(['Iteration ' num2str(iter)]);

   % plot weight density
   if (ismember(iter, displayiters))
      subplot(displayrows, displaycols, whichplot);  setup_axis;
      weight_density_plot(myboost, 'markercolor');  hold on;
      plot(x, y, 'k--');
      axis([0 1 0 1]);
      xlabel('\it{x_1}');  ylabel('\it{x_2}');
      title([starttext{whichplot} '\sl{' int2str(iter) ' iterations}']);
      axis square;
      set(gca, 'xtick', [], 'ytick', []);
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
