function [x, y, w] = get_xyw(obj, s, varargin)

% GET_XYW versatile parameter handling for (x, y, w) function
%
% SYNTAX:
%
% [x, y, w] = get_xyw(obj, s, dataset, [w])
% [x, y, w] = get_xyw(obj, s, x, y, [w])
%
% S is the string that describes the name of the function
%
% FIXME: comment

% get_xyw.m
% Jeremy Barnes, 23/4/1999
% $Id$


if (length(varargin) == 0)
   error([s ': not enough arguments given']);

elseif (length(varargin) == 1)
   % Must be just a dataset.  Check that this is so, and extract our x
   % and y parameters from it.

   d = varargin{1}{1};

   [x, y] = check_dataset(obj, s, d);

   w = ones(length(y), 1);
   
elseif (length(varargin) == 2)
   % Either we have a dataset followed by weights, or a {x, y} set.  We
   % can determine which case by looking at the type of the first
   % parameter.
   
   if (isa(varargin{1}{1}, 'double'))
      % We have an {x, y} pair
      
      x = varargin{1}{1};
      y = varargin{2}{1};
      
      check_x(obj, s, x);
      check_y(obj, s, x, y);
      
      w = ones(length(y), 1);
      
   else
      % We have a dataset followed by weights
      
      d = varargin{1}{1};
      
      [x, y] = check_dataset(obj, s, d);
      
      w = varargin{2}{1};
      
      check_w(obj, s, x, y, w);
   end
   
elseif (length(varargin) == 3)
   % We have a x, then a y, then a w
   
   x = varargin{1}{1};
   y = varargin{2}{1};
   z = varargin{3}{1};
   
   check_x(obj, s, x);
   check_y(obj, s, x, y);
   check_w(obj, s, x, y, w);
   
else
   % Too many arguments
   error([s ': too many parameters']);

end









function [x, y] = check_dataset(obj, s, d)

if (~isa(d, 'dataset'))
   error([s ': not enough arguments or first is not a dataset']);
elseif (numcategories(categories(d)) ~= numcategories(categories(obj)))
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
sy = size(y);

if (length(sx) ~= 2)
   error([s ': x vector must be a two-dimensional matrix']);
elseif (sx(2) ~= obj.dimensions)
   error([s ': dimensionality of x and classifier don''t match']);
elseif (sy(2) ~= 1)
   error([s ': y vector must have one column only']);
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






function check_w(obj, s, x, y, w)

if (~isa(w, 'double'))
   error([s ': w vector must be of type ''double''']);
end

sy = size(y);
sw = size(w);

if (sy ~= sw)
   error([s ': y and w must be the same size']);
end

