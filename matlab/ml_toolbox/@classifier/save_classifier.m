% @classifier/save_classifier.m
% Jeremy Barnes, 4/4/1999
% $Id$
% Time-stamp: <1999-04-04 20:34:30 dosuser>
%
% SAVE_CLASSIFIER - save a classifier to disk for later retreival
%
% SYNTAX:
%
% save_classifier(obj, 'filename')
%
% Saves the classifier to the disk file given.  All parts of the
% classifier are saved (including the type), so that it may be loaded in
% again exactly.  It is saved in a plain text format for maximum
% compatibility.
%

function save_classifier(obj, filename)

% PRECONDITIONS
% none



% POSTCONDITIONS
check_invariants(obj);

return;

