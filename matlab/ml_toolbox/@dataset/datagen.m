function obj_r = datagen(obj, type, n, sigma_x, Pe)

% DATAGEN generate data for a dataset
%
% SYNTAX:
%
% obj_r = datagen(obj, 'type', n, sigma_x, Pe)
%
% Generates a dataset of type 'TYPE', with N random values with position
% variance SIGMA_X and probability of misclassification error PE.  These
% samples will be added to the dataset D.
%
% The TYPE parameter may be one of the following (which describes the decision
% boundary):
%
%  'vert'               - vertical line up middle
%  'horiz' 		- horizontal line across middle
%  'diag'		- diagonal line
%  'ring'		- circle in the middle
%  '1quarter'		- quarter circle in corner
%  '4quarter'		- four quarter circles, one in each corner
%  'chess2x2'		- 2x2 chessboard configuration
%  'chess3x3'		- 3x3 chessboard configuration
%  'chess4x4'		- 4x4 chessboard configuration
%
% Note that data points start off evenly distributed in the unit square
% with its bottom left corner at the origin (however they may be moved
% outside this square by added noise).
%
% RETURNS:
%
% OBJ_R is a dataset containing the new values.

% @dataset/datagen.m
% Jeremy Barnes, 2/4/1999
% $Id$



% PRECONDITIONS
assert(obj, 'obj.initialised == 1');
assert(obj, 'numcategories(obj.categories) == 2'); % only generates binary data
assert(obj, 'obj.dimensions == 2'); % only generates 2D data

% Generate our real position vector.  This may be different from the
% observed position vector if we specify position noise.
x = rand(n, obj.dimensions);

% Based on this position vector and the geometry of our underlying
% distribution, classify each sample.

switch type
   case 'vert'
      y = (x(:, 1) < 0.5);
   case 'horiz'
      y = (x(:, 2) < 0.5);
   case 'diag'
      y = (x(:, 1) < x(:, 2));
   case 'ring'
      y = ((x(:, 1) - 0.5).^2 + (x(:, 2) - 0.5).^2 < 0.125);
   case '1quarter'
      y = (x(:, 1).^2 + x(:, 2).^2 < 0.5);
   case '4quarter'
      r2 = 0.25^2;
      y1 = (x(:, 1) - 0.0).^2 + (x(:, 2) - 0.0).^2;
      y2 = (x(:, 1) - 1.0).^2 + (x(:, 2) - 0.0).^2;
      y3 = (x(:, 1) - 0.0).^2 + (x(:, 2) - 1.0).^2;
      y4 = (x(:, 1) - 1.0).^2 + (x(:, 2) - 1.0).^2;
      y = ((y1 < r2) | (y2 < r2) | (y3 < r2) | (y4 < r2)); 
   case 'chess2x2'
      x1 = floor(x(:, 1) * 2.0);
      x2 = floor(x(:, 2) * 2.0);
      y  = (rem(x1+x2, 2) == 1);
   case 'chess3x3'
      x1 = floor(x(:, 1) * 3.0);
      x2 = floor(x(:, 2) * 3.0);
      y  = (rem(x1+x2, 2) == 1);
   case 'chess4x4'
      x1 = floor(x(:, 1) * 4.0);
      x2 = floor(x(:, 2) * 4.0);
      y  = (rem(x1+x2, 2) == 1);
   otherwise,
      error(['Unknown distribution type: "' type '"']);
end

% Now add noise.  This comes in two types: noise added that gives a
% probability of an error, and noise added to the position x.

if (sigma_x > eps)
   xnoise = normrnd(0, sigma_x, n, obj.dimensions);
   x = x + xnoise;
end

ynoise = (rand(n, 1) > Pe);
for i=1:n
   if (ynoise(i))
      y(i) = ~y(i);
   end
end

% Add these samples to our dataset

obj = addsamples(obj, x, y);


obj_r = obj;

% POSTCONDITIONS
check_invariants(obj_r);

return;