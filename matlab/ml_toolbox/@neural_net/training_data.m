function [samples, labels] = training_data(obj)

% TRAINING_DATA return data neural net is being trained by
%
% SYNTAX:
%
% [samples, labels] = training_labels(obj)
%
% FIXME: comment

% @neural_net/training_data.m
% Jeremy Barnes, 2/10/1999
% $Id$

samples = obj.x;
labels = obj.y;
