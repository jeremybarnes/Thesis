function [x, y] = get_xy(obj, s, args)

% GET_XY versatile parameter handling for (x, y) function
%
% SYNTAX:
%
% [x, y] = get_xy(obj, s, {dataset})
% [x, y] = get_xy(obj, s, {x, y})
%
% S is the string that describes the name of the function
%
% Designed to be called as [x, y] = get_xy(obj, 'name', varargin)
%
% FIXME: comment

% get_xy.m
% Jeremy Barnes, 2/10/1999
% $Id$

l = length(args);

if (l == 0)
   error([s ': not enough arguments given']);

elseif (l == 1)
   % Must be just a dataset.  Check that this is so, and extract our x
   % and y parameters from it.

   d = args{1};
   [x, y] = check_dataset(obj, s, d);
   
elseif (l == 2)
   % We have x then y
      
   x = args{1};
   y = args{2};
      
   check_x(obj, s, x);
   check_y(obj, s, x, y);

else
   % Too many arguments
   error([s ': too many parameters']);

end









function [x, y] = check_dataset(obj, s, d)

if (~isa(d, 'dataset'))
   error([s ': not enough arguments or first is not a dataset']);
elseif (numcategories(d) ~= numcategories(obj))
   error([s ': numcategories in dataset and classifier don''t' ...
	  ' match']);
elseif (dimensions(d) ~= dimensions(obj))
   error([s ': dimensionality of dataset and classifier don''t' ...
	  ' match']);
end

[x, y] = data(d);







function check_x(obj, s, x)

if (~isa(x, 'double'))
   error([s ': x vector must be of type ''double''']);
end

sx = size(x);

if (length(sx) ~= 2)
   error([s ': x vector must be a two-dimensional matrix']);
elseif (sx(2) ~= dimensions(obj))
   error([s ': dimensionality of x and classifier don''t match']);
end







function check_y(obj, s, x, y)


if (~isa(y, 'double'))
   error([s ': y vector must be of type ''double''']);
end

sx = size(x);
sy = size(y);

if (sx(1) ~= sy(1))
   error([s ': x and y must have the same number of rows']);
elseif (sy(2) ~= 1)
   error([s ': y vector must have one column only']);
end
