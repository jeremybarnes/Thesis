function overfitting

global EPSFILENAME

figure(1);  clf;  setup_figure;

% Parameters
yint = 2;
slope = 0.5;
noise = 0.5;

% x values
x = 0:10

% y values
y = slope .* x + yint;

% noisy y values
ynoise = y + randn(size(y)) * noise;

% regression fit
p2 = polyfit(x, ynoise, 1);
p10 = polyfit(x, ynoise, 10);

fitx = linspace(0, 10, 100);
fit2 = polyval(p2, fitx);
fit10 = polyval(p10, fitx);


% Draw graphs
subplot(1, 2, 1);  setup_axis;
plot(x, ynoise, 'kx');  hold on;
plot([0 10], [yint yint+10*slope], 'k--');
plot(fitx, fit2, 'k-');
title('(a)');
axis([0 10 -2 8]);
xlabel('\it{x_1}');
ylabel('\it{x_2}');
set(gca, 'xtick', [], 'ytick', []);


subplot(1, 2, 2);  setup_axis;
plot(x, ynoise, 'kx');  hold on;
plot([0 10], [yint yint+10*slope], 'k--');
plot(fitx, fit10, 'k-');
title('(b)');
axis([0 10 -2 8]);
xlabel('\it{x_1}');
ylabel('\it{x_2}');
set(gca, 'xtick', [], 'ytick', []);



set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps2');