function vcdim_problems

global EPSFILENAME

figure(1);  clf;  setup_figure;

radius = 1.01;
sinsize = 0.15;
sinperiods = 20;

% Generate a simple circle and a complex one
theta = linspace(0, 2*pi, 200);
r_circ = radius * ones(size(theta));
r_classifier = radius + sinsize .* sin(theta .* sinperiods);

circ_graph = r_circ .* exp(j * theta);
classifier_graph = r_classifier .* exp(j * theta);

subplot(1, 2, 1);  setup_axis;

plot(circ_graph, 'k-');  hold on;
plot(0, 0, 'kx');
xlabel('\it{x_1}');
ylabel('\it{x_2}');
title('(a) \sl{VCdim = 2}');
axis square;  axis([-1.2 1.2 -1.2 1.2]);

subplot(1, 2, 2);  setup_axis;
plot(classifier_graph, 'k-'); hold on;
plot(0, 0, 'kx');
plot(circ_graph, 'k--');
xlabel('\it{x_1}');
ylabel('\it{y_1}');
title('(b) \sl{VCdim = \infty}');
axis square;  axis([-1.2 1.2 -1.2 1.2]);

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');



