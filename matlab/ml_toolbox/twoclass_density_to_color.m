function the_image = twoclass_density_to_color(class1, class2)

% TWOCLASS_DENSITY_TO_COLOR convert class density to color values
% FIXME: comment

% twoclass_density_to_color.m
% Jeremy Barnes, 26/4/1999
% $Id$

% Min, max and range of each class
min1 = min(class1);
max1 = max(class1);
while (length(min1) > 1)
   min1 = min(min1);
   max1 = max(max1);
end
range1 = max1 - min1;

min2 = min(class2);
max2 = max(class2);
while (length(min2) > 1)
   min2 = min(min2);
   max2 = max(max2);
end
range2 = max2 - min2;

% Scale these two between 0 and 1
if (range1 == 0.0)
   class1 = zeros(size(class1));
else
   class1 = (class1 - min1) ./ range1;
end

if (range2 == 0.0)
   class2 = zeros(size(class2));
else
   class2 = (class2 - min2) ./ range2;
end

% Where blue is zero, we use 0-31.  Where red is zero, we use 32-63.
% Otherwise, we use 64-127.

redonly  = ((class2 <  0.125) & (class1 >= 0.125));
blueonly = ((class1 <  0.125) & (class2 >= 0.125));
mixed    = ((class1 >= 0.125) & (class2 >= 0.125));

% Redonly goes between 0 and 31, depending upon class1.  Blueonly goes
% between 32 and 63, depending upon class2.  Mixed goes between 64 and
% 127, depending upon 64*class1-8 + 8*class2-1.

the_image = redonly  .* (class1 * 31.99) + ...
            blueonly .* (class2 * 31.99 + 32) + ...
            mixed    .* (class1 * 64.00 - 8 + class2 * 8.00 - 1 + 64);

the_image = floor(the_image) + 1;

