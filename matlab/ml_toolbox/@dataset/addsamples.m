function obj_r = addsamples(obj, x, y)

% ADDSAMPLES add samples to a dataset
%
% SYNTAX:
%
% obj_r = addsamples(obj, x, y)
%
% This function adds the samples in the (X, Y) pair to the dataset OBJ.
% The X matrix contains the observations (with one observation per row),
% and the Y vector the classification of these observations.
%
% RETURNS:
%
% OBJ_R is a new dataset with the samples added to the old one.
%

% @dataset/addsamples.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS:
if (size(x) ~= [length(y) obj.dimensions])
   error('addsamples: size of x vector is incorrect');
end

% The implementation is simple: tack the data onto the end of the
% existing data.

obj.x_values = [obj.x_values; x];
obj.y_values = [obj.y_values; y];

% Now update our other variables

obj.numsamples = obj.numsamples + length(y);
obj_r = obj;

% POSTCONDITIONS:
check_invariants(obj_r);
