function [obj_r, context] = trainagain(obj)

% TRAINAGAIN perform another training iteration of the neural net
%
% SYNTAX:
%
% obj_r = trainagain(obj)
%
% Performs one iteration of supervised training on the neural network.
%
% [obj_r, context] = trainagain(obj)
%
% This form also returns information used by the TEST function in a
% structure array CONTEXT.
%
% RETURNS:
%
% A classifier that has had one more iteration of "boosting" performed on it

% @neural_net/trainagain.m
% Jeremy Barnes, 2/10/1999
% $Id$

% Get our data
[x_data, y_data] = training_data(obj);

% Train differently depending upon whether we are using the stochastic
% approximation to gradient descent or the exact for.

if (strcmp(get(obj, 'trainmethod'), 'stochastic'))
   % stochastic --> train on one sample at a time
   this_x = x_data(obj.samplenumber, :);
   this_y = y_data(obj.samplenumber);
   if (obj.samplenumber >= length(y_data))
      obj.samplenumber = 1;
   else
      obj.samplenumber = obj.samplenumber + 1;
   end
   
   obj_r = trainagain_guts(obj, this_x, this_y);
else
   % exact --> train on all data at once
   obj_r = trainagain_guts(obj, x_data, y_data);
end

% Return context info; nothing really useful here yet...
context.samplenumber = obj.samplenumber;




function obj_r = trainagain_guts(obj, x_data, y_data)

% TRAINAGAIN_GUTS perform a training iteration, using exact gradient
% descent (ie, calculating gradient based on all training samples
% provided).  Stochastic can be simulated by passing in only one training
% sample.

% First, we need to translate our output data into the "required" output
% data.  For example, 3 --> [0.1 0.1 0.1 0.9 0.1] if numcategories = 5.

c = numcategories(obj);
numsamples = length(y_data);
eta = obj.eta;
alpha = obj.alpha;

req_y = ones(numsamples, c) * 0.1;
for i=1:numsamples
   req_y(i, y_data(i)+1) = 0.9;
end

% We call our classify method in order to determine our gradients
[y, h_in, h_out, o_in, o_out] = classify(obj, x_data);

% Calculate output errors.  We make use of the derivitive of the transfer
% function here.
delta_o = node_transfer_deriv(obj, o_in, o_out) .* (req_y - o_out);

% Calculate error terms for hidden units.  This is more involved, as for
% each one we have to sum over the output units.  In addition, we discard
% the error term for the (unchangeable) bias unit.
sum_part = delta_o * obj.w_out';
sum_part(:, 1) = [];  % Discard bias unit errors
delta_h = node_transfer_deriv(obj, h_in, h_out) .* sum_part;

% Augment our inputs with the bias
o_in_bias = [ones(numsamples, 1) h_out];
h_in_bias = [ones(numsamples, 1) x_data];

% Work out update values
update_o = eta * o_in_bias' * delta_o;
update_h = eta * h_in_bias' * delta_h;

% Update all sets of values
obj.w_out = obj.w_out + update_o;
obj.w_hidden = obj.w_hidden + update_h;

% Finished!
obj_r = obj;
