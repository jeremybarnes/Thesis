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
      fill = 0.0;
      add = 1.0;
   case 'black'
      start_intensity = 0.0;
      end_intensity = 1.0;
      fill = 0.0;
      add = 0.0;
   otherwise,
      error('uniform_color_map: invalid background color');
end

% Calculate the intensities for each value
intensities = linspace(start_intensity, end_intensity, 2^bits)';

% FIXME: we should do some gamma correction here

% Work it out for one colour...
column1 = intensities;

l = length(intensities);


if (categories == 2)
end


% FIXME: this bit is a really messy, disgusting algorithm.  I'm sure that
% we can do MUCH better than this!

if (categories >= 2)
   % Put them together for two colours...
   column2 = zeros(l.^2, 2);
   
   for i = 1:l
      column2(l*(i-1)+1:l*i, :) = [ones(l, 1).*intensities(i) ...
		    column1];
   end
end

% And a similar thing for three colours...

if (categories == 3)
   column3 = zeros(l.^3, 3);

   l2 = l^2;
   
   for i = 1:l
      column3(l2*(i-1)+1:l2*i, :) = [ones(l2, 1).*intensities(i) ...
		    column2];
   end
end


switch (categories)
   case 1
      color_map = add - [column1 fill*ones(l, 2)];
   case 2
      color_map = add - [column2(:, 1) fill*ones(l^2, 1) column2(:, 2)];
   case 3
      color_map = add - [column3(:, 1) column3(:, 3) column3(:, 2)];
end




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

color_map = zeros(l^cat, 3);

if (model == 'additive')
   switch(cat)

      case 1
	 color_map = [intensities zeros(l, 2)];

      case 2
	 for i=0:l-1
	    color_map(i*l+1:i*l+l, :) = ...
		[intensities(i)*ones(l, 1) zeros(l, 1) intensities];
	 end

      case 3
	 for i=0:l-1
	    for j=0:l-1
	       color_map(i*l^2+j*l+1:i*l^2+j*l+l, :) = ...
		   [intensities(i)*ones(l, 1) intensities ...
		    intensities(j)*ones(l, 1)];
	    end
	 end
   end

else % model == 'subtractive'
   onesl1 = ones(l, 1);

   switch(cat)
      
      case 1
	 color_map = [onesl1 onesl1-intensities onesl1-intensities];

      case 2
	 for i=0:l-1
	    color_map(i*l+1:i*l+l, :) = ...
		[(1 - intensities(i))*onesl1


		   
	       

   for i=1:l
      for j=1:l
	 
      




% Work it out for one colour...
column1 = intensities;



if (categories == 2)
   
end


% FIXME: this bit is a really messy, disgusting algorithm.  I'm sure that
% we can do MUCH better than this!

if (categories >= 2)
   % Put them together for two colours...
   column2 = zeros(l.^2, 2);
   
   for i = 1:l
      column2(l*(i-1)+1:l*i, :) = [ones(l, 1).*intensities(i) ...
		    column1];
   end
end

% And a similar thing for three colours...

if (categories == 3)
   column3 = zeros(l.^3, 3);

   l2 = l^2;
   
   for i = 1:l
      column3(l2*(i-1)+1:l2*i, :) = [ones(l2, 1).*intensities(i) ...
		    column2];
   end
end


switch (categories)
   case 1
      color_map = add - [column1 fill*ones(l, 2)];
   case 2
      color_map = add - [column2(:, 1) fill*ones(l^2, 1) column2(:, 2)];
   case 3
      color_map = add - [column3(:, 1) column3(:, 3) column3(:, 2)];
end




