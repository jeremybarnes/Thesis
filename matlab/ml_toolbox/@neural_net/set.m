function obj_r = set(obj, varargin)

% SET set property values for an object
%
% SYNTAX:
%
% obj_r = set(obj, 'property', value, ...)
%
% This function modifies object properties.  To see which properties are
% available, use the "set" method with no arguments; this will print out
% a list of properties.

% @neural_net/set.m
% Jeremy Barnes, 2/10/1999
% $Id$

if (mod(length(varargin) , 2) ~= 0)
   error('set: must have (property, value) pairs');
end

if (length(varargin) == 0)
   disp('Available options:');
   disp('  trainmethod:     ["stochastic" | "exact"]');
   disp('  learningrate:    [0 - inf]');
   disp('  momentum:        [0 - inf]');
   return
end


for i=1:length(varargin)./2
   
   propname = varargin{i};
   propvalue = varargin{i+1};
   
   switch propname
      case 'trainmethod'
	 if (~strcmp(propvalue, 'stochastic') & ~strcmp(propvalue, 'exact'))
	    error('set: trainmethod must be "stochastic" or "exact"');
	 end
	 
	 obj.trainmethod = propvalue;
      
      case 'learningrate'
	 if (~isa(propvalue, 'double') | (propvalue < 0))
	    error('set: learningrate is a real > 0');
	 end
	 
	 obj.learningrate = propvalue;
	 
      case 'momentum'
	 if (~isa(propvalue, 'double') | (propvalue < 0))
	    error('set: momentum is a real > 0');
	 end
	 
	 obj.momentum = propvalue;
	 
      otherwise,
	 error(['set: invalid property name ' propname]');
   end
end
