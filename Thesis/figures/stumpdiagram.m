function stumpdiagram

global EPSFILENAME

randstate = 1001;

rand('state', randstate);

   
b = category_list('binary');
d = dataset(b, 2);
d = datagen(d, 'ring', 20, 0, 0);

s = decision_stump(b, 2);
s = train(s, d)


figure(1);  clf;

subplot(1, 2, 1);


plotboundary(s, [1 1; 0 0]);
text(0.3, 0.5, '+1');
text(0.8, 0.5, '-1');
axis square; axis([0 1 0 1]);
xlabel('x_1');
ylabel('x_2');
title('(a)');

subplot(1, 2, 2);
   
plotboundary(s, [1 1; 0 0]);
hold on;
dataplot(d);
   
xlabel('x_1');
ylabel('x_2');
axis square;
title('(b)');

   

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps');
