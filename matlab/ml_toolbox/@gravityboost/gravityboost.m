function obj = gravityboost(weaklearner, norm, gravity)

% GRAVITYBOOST boosting algorithm pulled towards a norm
%
% This is the constructor for the GRAVITYBOOST type.
%
% SYNTAX:
%
% obj = gravityboost(weaklearner, norm, gravity)
%
% GRAVITYBOOST is a less rigid form of normboost.  It still tries to get
% a low value of a norm, but instead of forcing the line search along a
% particular line it "pulls" it towards zero.
%
% The norm to pull towards a low value of is given by the parameter
% NORM.  For normal boosting, we use norm=1.
%
% The strength of the pull is given by the parameter GRAVITY.  For
% operation equivalent to NORMBOOST, use gravity=0.  Otherwise, some form
% of cross-valiadation should be used to choose the optimal value of
% GRAVITY.
%
% RETURNS:
%
% OBJ is the new gravityboost object.
%

% @gravityboost/gravityboost.m
% Jeremy Barnes, 15/8/1999
% $Id$

if ((nargin == 1) & isa(weaklearner, 'gravityboost'))
   % One parameter --> make a copy
   obj = weaklearner;
   return
elseif (nargin == 0)
   norm = 1.0;
   gravity = 0.1;
   parent = boost;
elseif (nargin == 1)
   norm = 1.0;
   gravity = 0.1;
   parent = boost(weaklearner);
elseif (nargin == 2)
   gravity = 0.1;
   parent = boost(weaklearner);
else
   parent = boost(weaklearner);
end

obj.lambda = gravity;

% construct class and define superior/inferior relationship
obj = class(obj, 'gravityboost', parent);
superiorto('double', 'classifier', 'boost', 'normboost');
