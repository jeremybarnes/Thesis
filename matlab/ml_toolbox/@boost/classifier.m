function obj = classifier(classes, dimensions)
% CLASSIFIER abstract ancestor class for a classification machine
%
% This is the constructor for the classifier type.
%
% SYNTAX:
%
% obj = classifier(classes, dimensions)
%
% Creates a classifier.  Not much use as this is just an abstract class,
% anyway.
%
% DIMENSIONS specifies the number of dimensions that the independent
% variable will have.
%
% CLASSES is a CLASSLABEL object that specifies the classes to be used in
% the data.
%
% RETURNS:
%
% OBJ is the new classifier.
%

% classifier/classifier.m
% Jeremy Barnes, 4/4/1999
% $Id$


% PRECONDITIONS
if (dimensions <= 0)
   error('classifier: DIMENSIONS must be >= 1');
end

if (~isa(classes, 'classlabel'))
   error('classifier: CLASSES needs to be a CLASSLABEL');
end


% initialisation of variables in obj
obj.initialised = 1;
obj.dimensions = dimensions;
obj.classes = classes;
obj.trained_samples = 0;

% construct class and define superior/inferior relationship
obj = class(obj, 'classifier');
superiorto('double');


% POSTCONDITIONS
check_invariants(obj);

return;
