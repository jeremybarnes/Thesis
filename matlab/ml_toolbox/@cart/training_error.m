function e = training_error(obj)

% TRAINING_ERROR return the training error of a CART object
%
% SYNTAX:
%
% e = training_error(obj)
%
% RETURNS:
%
% The training error is the sum of the weights of samples that are
% classified incorrectly.  This is returned in E.

% @cart/training_error.m
% Jeremy Barnes 22/4/1999
% $Id$

% PRECONDITIONS:
if (obj.tree.totalweight == 0.0)
   error('training_error: no weight in samples');
end


e = obj.tree.incorrectweight;


% POSTCONDITIONS:
check_invariants(obj);
