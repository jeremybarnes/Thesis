function test_neural_net_sonar

% Tests it on the sonar dataset; draws a graph

hidden = 4;
iterations = 2000;

[traind, testd] = partition(dataset('sonar'), 2/3, 'random')

nn = neural_net(hidden, dimensions(traind), numcategories(traind));
nn = set(nn, ...
	 'momentum', 0.3, ...
	 'trainmethod', 'stochastic', ...
	 'learningrate', 0.3);
get(nn)

[trained, train_err, test_err] = test(nn, traind, testd, iterations);

figure(1);  clf;
it = 1:iterations;
plot(it, train_err, 'b-');  hold on;
plot(it, test_err, 'r-');

save('neural_net_sonar_results');