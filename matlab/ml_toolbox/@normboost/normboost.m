function obj = normboost(weaklearner, norm)

% NORMBOOST normed boosting algorithm
%
% This is the constructor for the NORMBOOST type.
%
% SYNTAX:
%
% obj = normboost(weaklearner, norm, value)
%
% NORMBOOST is a boosting algorithm that searches through a subset
% of the function space where the functional norm is equal to 1.
% In performing its line searches, it sticks to this line.
%
% RETURNS:
%
% OBJ is the new normboost object.
%

% @normboost/normboost.m
% Jeremy Barnes, 15/8/1999
% $Id$

if ((nargin == 1) & isa(weaklearner, 'normboost'))
   % One parameter --> make a copy
   obj = weaklearner;
   return
elseif (nargin == 0)
   norm = 1.0;
   parent = boost;
elseif (nargin == 1)
   norm = 1.0;
   parent = boost(weaklearner);
else
   parent = boost(weaklearner);
end

obj.p = norm;

% Here we store the "margins" of the samples, ie y_i F(x_i) for efficient
% computation of the cost function stuff
obj.margins = [];

% construct class and define superior/inferior relationship
obj = class(obj, 'normboost', parent);
superiorto('double', 'classifier', 'boost');
