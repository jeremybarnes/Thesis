function test_neural_net

% TEST_NEURAL_NET test out the neural network code

% test_neural_net.m
% Jeremy Barnes, 3/10/1999
% $Id$

% We create a simple classifier which learns a binary relationship

train_data_x = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
train_data_y = [0; 1; 2; 3];

nn = neural_net(2, 4, 4);
nn = set(nn, 'trainmethod', 'exact');

% Train the neural network

nn = train(nn, 1000, train_data_x, train_data_y);


% Display our results

[y, h_in, h_out, o_in, o_out] = classify(nn, train_data_x)

