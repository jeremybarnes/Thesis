function stumpcandidates

global EPSFILENAME

figure(1);  clf;

setup_figure;

datax = [0.1 0.5 0.8];
datay = [0.7 0.2 0.5];
dataxs = sort(datax);
datays = sort(datay);
l = length(datax);

xcand = (dataxs(1:l-1) + dataxs(2:l)) ./ 2;
ycand = (datays(1:l-1) + datays(2:l)) ./ 2;


% Part a : x candidate points

subplot(1, 2, 1);  setup_axis;

plot(datax, datay, 'kx');  hold on;

for i=1:length(datax)
   x = datax(i);  y = datay(i);
   plot([x x], [0 y], 'k:');
   plot(x, 0, 'k+');
end

for i=1:length(xcand)
   x = xcand(i);
   plot(x, 0, 'k.');
end

xlabel('x_1');  ylabel('x_2');  title('(a)');
axis square;  axis([0 1 0 1]);

set(gca, 'xtick', [], 'ytick', []);

% Part b : y candidate points

subplot(1, 2, 2);  setup_axis;

plot(datax, datay, 'kx');  hold on;

for i=1:length(datax)
   x = datax(i);  y = datay(i);
   plot([0 x], [y y], 'k:');
   plot(0, y, 'k+');
end

for i=1:length(xcand)
   y = ycand(i);
   plot(0, y, 'k.');
end

xlabel('x_1');  ylabel('x_2');  title('(b)');
axis square;  axis([0 1 0 1]);
set(gca, 'xtick', [], 'ytick', []);

set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-depsc');