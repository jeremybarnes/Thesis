function classification_problem

global EPSFILENAME

% Draw a figure which shows the input to and output from a classification
% problem

yint = 0.8;
slope = -0.05;

x = rand(1, 10);
y = rand(1, 10);

class = (y - yint) > slope * x;

class1 = find(class == 1);
class0 = find(class == 0);

class1x = x(class1);  class1y = y(class1);
class0x = x(class0);  class0y = y(class0);

figure(1);  clf;
setup_figure;

subplot(1, 2, 1);  setup_axis;
plot(x, y, 'k.', 'markersize', 10);
title('(a) \sl{input}');
set(gca, 'xtick', [], 'ytick', []);
xlabel('\itx_1');  ylabel('\itx_2');
axis square;

subplot(1, 2, 2);  setup_axis;
plot(class1x, class1y, 'kx');  hold on;
plot(class0x, class0y, 'ko');
plot([0 1], [yint yint+slope], 'k--');
title('(b) \sl{output}');
set(gca, 'xtick', [], 'ytick', []);
xlabel('\itx_1');  ylabel('\itx_2');
axis square;

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps');


