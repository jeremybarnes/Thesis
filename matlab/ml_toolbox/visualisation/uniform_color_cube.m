function color_map = uniform_color_cube(categories, bits, background)

% UNIFORM_COLOR_MAP color cube for displaying orthogonal categories
%
% SYNTAX:
%
% color_map = uniform_color_cube(categories, bits, 'background')
%
% This function generates a 2^bits * categories by 3 matrix which can be
% used as a colormap for the independent display of data for up to three
% orthoginal sets of data (encoded in the red, green and blue values of
% the colormap.
%
% If specified, the 'BACKGROUND' parameter controls the background colour
% of the graph.  Currently, the only allowable value is 'black' --
% otherwise, it defaults to white.
%
% RETURNS:
%
% The specified colormap.  The first category goes in red, followed by
% blue and then green.

% uniform_color_map.m
% Jeremy Barnes, 23/4/1999
% $Id$

% PRECONDITIONS:

if ((categories < 1) | (categories > 3))
   error(['uniform_color_cube: categories must be between 1 and 3' ...
	  ' inclusive']);
end

if (nargin < 3)
   background = 'white';
end

switch (background)
   case 'white'
      start_intensity = 0.0;
      end_intensity = 0.75;
      model = 'subtractive';
   case 'black'
      start_intensity = 0.0;
      end_intensity = 1.0;
      model = 'additive';
   otherwise,
      error('uniform_color_map: invalid background color');
end

% Calculate the intensities for each value
intensities = linspace(start_intensity, end_intensity, 2^bits)';





% FIXME: we should do some gamma correction here


l = length(intensities);

color_map = zeros(l^categories, 3);

switch(categories)
   
   case 1
      color_map = [intensities zeros(l, 2)];
      
   case 2
      for i=0:l-1
%	 color_map(i*l+1:i*l+l, :) = ...
%	     [intensities(i+1)*ones(l, 1) zeros(l, 1) intensities];

	 color_map(i*l+1:i*l+l, :) = ...
	     construct_rb2(intensities(i+1)*ones(l, 1), intensities);


      end
      
   case 3
      for i=0:l-1
	 for j=0:l-1
	    color_map(i*l^2+j*l+1:i*l^2+j*l+l, :) = ...
		[intensities(i+1)*ones(l, 1) intensities ...
		 intensities(j+1)*ones(l, 1)];
	 end
      end
end


%if (model == 'subtractive')
%   color_map = cmy2rgb(color_map);
%end
      






function rgb = cmy2rgb(cmy)

% FIXME: comment
%
% Not a particularly good system -- this is a very complicated topic!
%
% Based upon code from the "Borland Delphi Knowledge Base", which is at
% <http://www.borland.com/devsupport/delphi/qanda/1767.html>
%
% For a better exploration of the issues involved, have a look at the
% Colour Spaces FAQ, which is at
% <http://www.inforamp.net/~poynton/PDFs/ColorFAQ.pdf>.

C = cmy(:, 1);
M = cmy(:, 2);
Y = cmy(:, 3);

R = 1 - C;
G = 1 - M;
B = 1 - Y;

rgb = [R G B];



function color = construct_rb(r, b)

% Given the two levels of red and blue that we want to see, construct a
% colour that has the following properties:
%
% * if r = b = 0, then the colour is white
% * if r = 1 and b = 0, then the colour is a dark red
% * if r = 0 and b = 1, then the colour is a dark blue
% * if r = b = 1, then the colour is a purple
%
% So basically, our colour starts off at white and gets darker (towards
% red or blue) as the levels increase.

% Our green component depends upon the average of the red and blue
% components.

g = (1 - r + 1 - b) / 2;

r = 1 - (r * 0.75); % leave some red in there at maximum "brightness"
                    % (darkness)

b = 1 - (b * 0.75); % same for blue

color = [r g b];




function color = construct_rb2(r, b)

% This time, work out an ideal colour for the red, an ideal for the blue,
% and then combine them.

ideal_r = [ones(size(r))  1-r  1-r];
ideal_b = [1-b  1-b  ones(size(b))];

% combine them

color = (ideal_r + ideal_b) / 2;


R = (r .* ideal_r(:, 1)   + (1-r).*b.*ideal_b(:, 1));
G = (r.*ideal_r(:, 2) + b.*ideal_b(:, 2)) / 2;
B = ((1-b).*r.*ideal_r(:, 3) + b.*ideal_b(:, 3));


color = [R G B];

