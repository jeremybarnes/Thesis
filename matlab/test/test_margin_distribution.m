function test_margin_distribution

d = dataset(2, 2);
dtr = datagen(d, 'ring', 200, 0, 0.2);
dts = datagen(d, 'ring', 1000, 0, 0);

w = decision_stump(2, 2);

b = boost(w);

[b, tre, tse, bw, bm, ew, em] = test(b, dtr, dts, 2000, 'nosave');

% Find out what the values should be
y = y_values(dtr)*2 - 1;
bm = bm .* y;
em = em .* y;


figure(1);  clf;
iter = 1:length(tre);
plot(iter, tre, 'b-');  hold on;
plot(iter, tse, 'r-');

figure(2);  clf;

plot_margin_distribution(bm, 'linestyle', 'r-', 'normalise', 1);  hold on;
plot_margin_distribution(em, 'linestyle', 'b-', 'normalise', 1);
