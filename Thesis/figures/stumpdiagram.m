function stumpdiagram

global EPSFILENAME

randstate = 1001;

rand('state', randstate);

   
d = dataset(2, 2);
d = datagen(d, 'ring', 20, 0, 0);

s = decision_stump(2, 2);
s = train(s, d)


figure(1);  clf;  setup_figure;

subplot(1, 2, 1);  setup_axis;


plotboundary(s, [1 1; 0 0]);
text(0.3, 0.5, '+1', 'fontname', 'times');
text(0.8, 0.5, '-1', 'fontname', 'times');
axis square; axis([0 1 0 1]);
xlabel('\it{x_1}');
ylabel('\it{x_2}');
title('(a)');

subplot(1, 2, 2);  setup_axis;
   
plotboundary(s, [1 1; 0 0]);
hold on;
dataplot(d);
   
xlabel('\it{x_1}');
ylabel('\it{x_2}');
axis square;
title('(b)');

   

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps');
