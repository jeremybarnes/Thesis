function e = training_error(obj)

% TRAINING_ERROR return the training error of a DECISION_STUMP object
%
% SYNTAX:
%
% e = training_error(obj)
%
% RETURNS:
%
% The training error is the sum of the weights of samples that are
% classified incorrectly.  This is returned in E.

% @boost/training_error.m
% Jeremy Barnes 22/4/1999
% $Id$

% PRECONDITIONS:
% none

e = empirical_risk(obj, obj.x, obj.y);


% POSTCONDITIONS:
check_invariants(obj);
