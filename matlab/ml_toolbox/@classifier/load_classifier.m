% @classifier/load_classifier.m
% Jeremy Barnes, 4/4/1999
% $Id$
% Time-stamp: <1999-04-04 20:34:13 dosuser>
%
% LOAD_CLASSIFIER - load a previously saved classifier from disk
%
% SYNTAX:
%
% obj = load_classifier('filename')
%
% Loads the classifier from the named disk file.  This loads every single
% value necessary to reconstruct the classifier, including the classifier
% type.
%
% RETURNS:
%
% obj is a classifier of the type given by the file, in exactly the state
% that it was saved in.
%

function obj = load_classifier(filname)

% PRECONDITIONS
% none



% POSTCONDITIONS
check_invariants(obj);

return;

