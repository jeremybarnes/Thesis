function color_map = twoclass_colormap(background)

% TWOCLASS_COLORMAP colormap for displaying density of two classes
%
% SYNTAX:
%
% color_map = twoclass_colormap('background')
%
% BACKGROUND can be either 'white' or 'black'.
%
% This function creates a colormap suitable for displaying the density of
% two classes (red and blue).  The colormap is optimised to display areas
% of only one class with a high colour resolution (32 levels);
% combinations of the twoclasses have a much lower resolution (9 levels).
%
% The colormap is organised as follows:
%
% 0-31    Category 1 (red), minimum to maximum level
% 32-63   Category 2 (blue), minimum to maximum level
% 64-128  Mixtures (red in most sig. 3 bits, blue in least sig. 3 bits)
%
% The companion function, TWOCLASS_DENSITY_TO_COLOR, can be used to
% translate class densities into color values.

% twoclass_colormap.m
% Jeremy Barnes, 25/4/1999
% $Id$

% PRECONDITIONS:
switch (background)
   case {'black', 'white'}
   otherwise,
      error(['twoclass_colormap: background must be ''white'' or' ...
	     ' ''black''']);
end


% Our colour levels
color_levels = linspace(0, 1, 32)';

% FIXME: it would be nice to gamma-correct these!


% Create our red-only and blue-only sections
switch (background)
   case 'white'
      red_only = [ones(32, 1) ones(32, 1) - color_levels ones(32, 1) - ...
		  color_levels];
      blue_only = [ones(32, 1) - color_levels ones(32, 1) - color_levels ...
		   ones(32, 1)];
   case 'black'
      red_only =  [color_levels  zeros(32, 1)  zeros(32, 1)];
      blue_only = [zeros(32, 1)  zeros(32, 1)  color_levels];
end

% Now for our mixed section.  This is done quite differently for each
% background.
%
% In the case of a black background, the red and blue components are
% simply added together as they are orthogonal.
%
% In the case of a white background, the red and blue components are not
% orthogonal and we have to do some more work.

switch (background)


   case 'black'
      mixed_levels = linspace(0, 1, 9)';
      mixed_levels(1) = []; % remove our zero level

      mixed = zeros(64, 3);

      for i=1:8
	 mixed((i-1)*8 + 1  :  i*8, :) = ...
	     [ones(8, 1) .* mixed_levels(i)  zeros(8, 1)  mixed_levels];
      end


   case 'white'
      mixed_levels = linspace(0, 1, 9)';
      mixed_levels(1) = []; % remove our zero level

      mixed = zeros(64, 3);

      for i=1:8
	 mixed((i-1)*8 + 1  :  i*8, :) = ...
	     construct_rb(ones(8, 1) .* mixed_levels(i), mixed_levels);
      end
      

end


color_map = [red_only; blue_only; mixed];








function color = construct_rb(r, b)

% FIXME: comment
% Could be better (that max introduces a greeny tinge) but will do for
% the time being.

R = r ./ (r+b) .* (2 - max([1-r 1-b]')');
B = b ./ (r+b) .* (2 - max([1-r 1-b]')');
G = 1 - (r+b) ./ 2;

color = [R G B];

