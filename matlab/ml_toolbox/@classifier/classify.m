function y = classify(obj, x)

% CLASSIFY use a classifier to classify a dataset
%
% SYNTAX:
%
% y = classify(obj, x)
%
% Classifies the data in x using the classifier obj.  Returns the class
% labels in y.
%
% RETURNS:
%
% The classification in y.


% @classifier/classify.m
% Jeremy Barnes, 4/4/1999
% $Id$

% PRECONDITIONS
% none

error('classify: abstract method called');


% POSTCONDITIONS
check_invariants(obj);

return;

