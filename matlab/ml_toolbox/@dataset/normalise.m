function obj_r = normalise(obj)

% NORMALISE scale columns in a dataset so that range is +-1
%
% SYNTAX:
%
% obj_r = normalise(obj)
%
% This function scales each column (attribute) of a dataset by the
% amount col = col / max(abs(col)), which results in the maximum
% magnitude of a column being 1.
%
% Mainly used on neural networks to avoid differing attributes
% having differing importance.

% @dataset/normalise.m
% Jeremy Barnes, 2/11/1999
% $Id$

d = dimensions(obj);

for i=1:d
   obj.x_values(:, i) = obj.x_values(:, i) ...
       ./ max(abs(obj.x_values(:, i)));
end

obj_r = obj;
