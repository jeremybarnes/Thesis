function obj_r = randomize(obj)

% RANDOMIZE randomly shuffle samples in a dataset
%
% SYNTAX:
%
% obj_r = randomize(obj)
%
% This function returns another dataset in OBJ_R, with the same samples
% as OBJ but in a different (random) order.

% @dataset/randomize.m
% Jeremy Barnes, 3/10/1999
% $Id$

s = numsamples(obj);
d = dimensions(obj);

% Create a big matrix with a random value, x values, and y values
bigm = [rand(s, 1) obj.x_values obj.y_values];

% Sort it based on these random values
bigm = sortrows(bigm);

% Split it back up again
obj.x_values = bigm(:, 2:d+1);
obj.y_values = bigm(:, d+2);

obj_r = obj;