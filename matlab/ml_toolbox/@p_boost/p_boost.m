function obj = p_boost(weaklearner, p)

% P_BOOST tunable version of the BOOST classifier
%
% This is the constructor for the P_BOOST type.
%
% SYNTAX:
%
% obj = p_boost(weaklearner, p, maxiterations)
%
% Creates a boosted classifier, based upon the WEAKLEARNER.  The
% dimensions and categories of the weak learner are copied as the
% dimensions and categories of the boosted learner.
%
% MAXITERATIONS specifies the maximum number of times that the boosting
% algorithm can be iterated.  It is used to allocate storage ahead of
% time to improve efficiency.
%
% P is the tunable parameter.  P=1 is equivalent to the normal boosting
% algorithm.  Lower values of P are more agressive in penalising
% versions of the underlying classifier that perform poorly.  Higher
% values allow even poor versions to have a significant effect on the
% overall classifier.
%
% RETURNS:
%
% OBJ is the new P_BOOST object.
%

% @p_boost/p_boost.m
% Jeremy Barnes, 27/4/1999
% $Id$

if (nargin == 0)
   weaklearner = decision_stump;
   p = 1;
end

if ((nargin == 1) & (isa(weaklearner, 'p_boost')))
   obj = weaklearner;
   return;
end

parent = boost(weaklearner);

obj.p = p;

% construct class and define superior/inferior relationship

obj = class(obj, 'p_boost', parent);
superiorto('double', 'boost');
