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

% @decision_stump/training_error.m
% Jeremy Barnes 22/4/1999
% $Id$

% PRECONDITIONS:
% none

e = obj.trainingerror;


% POSTCONDITIONS:
check_invariants(obj);
