function obj = normboost2(weaklearner, norm)

% NORMBOOST2 normed boosting algorithm (version 2)
%
% This is the constructor for the NORMBOOST2 type.
%
% SYNTAX:
%
% obj = normboost2(weaklearner, norm, value)
%
% NORMBOOST2 is a boosting algorithm that searches through a subset
% of the function space where the functional norm is equal to 1.
%
% The difference between it and normboost is that the line searches are
% allowed over an area where the norm is not equal to one, and then
% normalised back onto this line later.
%
% RETURNS:
%
% OBJ is the new normboost object.
%

% @normboost2/normboost2.m
% Jeremy Barnes, 15/8/1999
% $Id$

if ((nargin == 1) & (isa(weaklearner, 'normboost2')))
   % One parameter --> make a copy
   obj = weaklearner;
   return
end

if (nargin == 0)
   % Zero parameters: choose defaults
   parent = normboost;
else
   parent = normboost(weaklearner, norm);
end

obj.dummy = 1; % Dummy field to stop complaints

% construct class and define superior/inferior relationship
obj = class(obj, 'normboost2', parent);
superiorto('double', 'classifier', 'boost', 'normboost');

