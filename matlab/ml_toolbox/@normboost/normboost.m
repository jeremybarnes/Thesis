function obj = normboost(weaklearner, norm, value)

% NORMBOOST normed boosting algorithm
%
% This is the constructor for the NORMBOOST type.
%
% SYNTAX:
%
% obj = normboost(weaklearner, norm, value)
%
% FIXME: comment
%
% Currently, the only possibility for norm is 'exp'.
%
% RETURNS:
%
% OBJ is the new boost object.
%

% @normboost/normboost.m
% Jeremy Barnes, 15/8/1999
% $Id$

parent = boost(weaklearner);
obj = struct(parent);

obj.norm = norm;
obj.value = value;

% construct class and define superior/inferior relationship
obj = class(obj, 'normboost', parent);
superiorto('double', 'classifier', 'boost', 'boost2');
