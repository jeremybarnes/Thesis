function ring_distribution

global EPSFILENAME

figure(1);  clf;  setup_figure;

d = dataset(2, 2);
d = datagen(d, 'ring', 20, 0, 0);

th = linspace(0, 2*pi);
r = sqrt(0.125);
cx = 0.5;
cy = 0.5;

dataplot(d);  hold on;
plot(cx + r*sin(th), cy+r*cos(th), 'k--');

axis square;
xlabel('\it{x_1}');
ylabel('\it{x_2}');

set(1, 'paperposition', [1 1 6 2.5]);

print(EPSFILENAME, '-f1','-deps2', '-adobecset');



