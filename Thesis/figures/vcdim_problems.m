function vcdim_problems

global EPSFILENAME

figure(1);  clf;

radius = 1.01;
sinsize = 0.15;
sinperiods = 20;

% Generate a simple circle and a complex one
theta = linspace(0, 2*pi, 200);
r_circ = radius * ones(size(theta));
r_classifier = radius + sinsize .* sin(theta .* sinperiods);

circ_graph = r_circ .* exp(j * theta);
classifier_graph = r_classifier .* exp(j * theta);

subplot(1, 2, 1);
plot(circ_graph, 'k-');  hold on;
plot(0, 0, 'kx');
xlabel('x_1');
ylabel('x_2');
title('(a)');
axis square;  axis tight;

subplot(1, 2, 2);
plot(classifier_graph, 'k-'); hold on;
plot(0, 0, 'kx');
plot(circ_graph, 'k--');
xlabel('x_1');
ylabel('y_1');
title('(b)');
axis square;  axis tight;

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');



