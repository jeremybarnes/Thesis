% @class/class.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% CLASSLABEL - label used to classify a set of classes
%
% This is the constructor for the class CLASSLABEL
%
% SYNTAX:
%
% obj = classlabel({'label0', 'label1', ...})
%
% This abstract data type holds information about the labels of classes
% used in a classifier.  You pass it a list of textual labels, which
% correspond to the classes of your data.  They are mapped onto the
% numbers 0, 1, 2, ...
%
% RETURNS:
%
% A classlabel object with the specified labels.
%
% METHODS:
%
% numlabels(obj)
%    - returns the number of labels stored
%
% labels(obj)
%    - returns a cell array of the labels stored
%
% labelnum(obj, i)
%    - returns label number i

function obj = classlabel(labels)

% PRECONDITIONS
if (length(labels) == 0)
   error('You must specify at least one label.');
end


% initialisation of variables in obj
obj.initialised = 1;
obj.numlabels = length(labels);
obj.labels = labels;


% construct class and define superior/inferior relationship
obj = class(obj, 'classlabel');
superiorto('double');



% POSTCONDITIONS
global_postconditions(obj);

return;




