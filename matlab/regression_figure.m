figure(1);
clf;
x = linspace(0,1,101);
y = x.^3 - 2*x.^2 + x;
y(50:101) = y(50:101) * 0.8;
plot(x(1:49), y(1:49)*10);
hold on;
plot(x(50:101), y(50:101)*10);
xlabel('x (input)');
ylabel('y (regression output');

set(1, 'PaperUnits', 'inches', 'PaperPosition', [0 0 4 3]);
print -teps e:\Uni\engn4000\Thesis\figures\regression_problem.eps

