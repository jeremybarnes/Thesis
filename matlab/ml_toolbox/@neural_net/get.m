function [varargout] = get(obj, varargin)

% GET property values for an object
%
% SYNTAX:
%
% [value1, value2, ...] = get(obj, 'property1', 'property2', ...)
%
% This function prints object properties.  The property values specified
% are returned in the output variables (there must be the right amount).
% If no properties are specified, then nothing is returned but all
% property values are printed.

% @neural_net/get.m
% Jeremy Barnes, 2/10/1999
% $Id$

if (nargout ~= nargin-1)
   error('get: invalid number of output arguments');
end

if (length(varargin) == 0) % Display all options
   varargin = {'trainmethod', 'learningrate', 'momentum', 'progressinterval'};
   printonly = 1;
   disp('neural_net options:');
else
   printonly = 0;
end


for i=1:length(varargin)
   
   propname = varargin{i};
   
   switch propname
      case 'trainmethod'
	 propvalue = obj.trainmethod;
	 proptext = propvalue;
	 
      case 'learningrate'
	 propvalue = obj.eta;
	 proptext = num2str(propvalue);
	 
      case 'momentum'
	 propvalue = obj.alpha;
	 proptext = num2str(propvalue);
	 
      case 'progressinterval'
	 propvalue = obj.progressinterval;
	 proptext = num2str(propvalue);
      
      otherwise,
	 error(['get: invalid property name ' propname]');
   end

   if (printonly)
      disp([propname ': ' proptext]);
   else
      varargout{i} = propvalue;
   end
end

