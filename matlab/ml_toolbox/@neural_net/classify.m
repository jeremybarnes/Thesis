function [y, h_in, h_out, o_in, o_out] = classify(obj, x)

% CLASSIFY produce labels from samples using thresholded neural net
%
% SYNTAX:
%
% labels = classify(obj, samples)
%
% Classifies the data in SAMPLES using the classifier obj.  Returns the
% LABELS in y.
%
% [labels, h_in, h_out, o_in, o_out] = classify(...)
%
% Returns also the (input, output) pairs of the hidden and output nodes
% when classifying this data.  Designed to be used by backpropegation
% algorithm, but may be used for other purposes also.  This information
% has one row per sample, one column per node.

% @neural_net/classify.m
% Jeremy Barnes, 25/4/1999
% $Id$

% This is not really not all that tricky.  We simply evaluate the network
% for the data given and return our results.

% First, calculate the inputs for each hidden unit
s = size(x);
numsamples = s(1);
x0 = ones(numsamples, 1); % dummy "x0" input always one for bias
h_in = [x0 x] * obj.w_hidden;

% Run the sigmoid function
h_out = node_transfer_function(obj, h_in);

% We now have a matrix... rows are outputs of hidden units, columns are
% different samples.  We proceed to feed this forward into our output
% network.  We also add ones again for the hidden units.
o_in = [ones(numsamples, 1) h_out] * obj.w_out;

o_out = node_transfer_function(obj, o_in);

% Finally, we select the output unit with the highest output as our
% category value.  This loop is _real_ slow in MATLAB; it may be that
% using C is worthwile.

m = max(o_out, [], 2);
y = zeros(numsamples, 1);
for i=1:numsamples
   max_index = find(o_out(i, :) == m(i));
   if (length(max_index) > 1)
      max_index = max_index(1);
   end

   y(i) = max_index - 1; % -1 because categories go from 0 to n-1
end
