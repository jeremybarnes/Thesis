function n = pnorm(vec, pval)

% PNORM calculate the p-norm of a vector
%
% P is a global variable.

% pnorm.m
% Jeremy Barnes, 30/7/1999
% $Id$

if (nargin == 1)
   global p
else
   p = pval;
end

n = sum(vec .^ p) .^ (1/p);
