function m = findmax(a)

% FINDMAX return the index of the maximum element in each row
%
% SYNTAX:
%
% m = findmax(a)
%
% This function returns a column vector M which contains the index
% of the maximum element in each row of A.
%
% For example, findmax([8 1 12   = [3
%                       9 8  7])    1].
%
% LIMITATIONS:
%
% * Currently only works on two dimensional data
% * Currently does not handle complex data (real parts are used)

% findmax.m
% Jeremy Barnes, 2/11/1999
% $Id$

% Note: coded in C to speed up; this is very slow under native MATLAB.

s = size(a);
m1 = max(a, [], 2);
m = zeros(s(1), 1);
for i=1:s(1)
   max_index = find(a(i, :) == m1(i));
   if (length(max_index) > 1)
      max_index = max_index(1);
   end

   m(i) = max_index;
end
