function obj = normboost(weaklearner, p)

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
% RETURNS:
%
% OBJ is the new boost object.
%

% @normboost/normboost.m
% Jeremy Barnes, 15/8/1999
% $Id$

parent = boost(weaklearner);

obj.p = p;

% Here we store the "margins" of the samples, ie y_i F(x_i) for efficient
% computation of the cost function stuff
obj.margins = [];

% construct class and define superior/inferior relationship
obj = class(obj, 'normboost', parent);
superiorto('double', 'classifier', 'boost', 'boost2');
