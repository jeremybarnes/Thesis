function wl = wl_instance(obj, range)

% WL_INSTANCE return instance(s) of the weaklearner
%
% SYNTAX:
%
% wl = wl_instance(obj, range)
%
% This function is used to return one or more (trained) instances of the
% weak learning algorithm.  RANGE indicates for which iterations the weak
% learning algorithm will be returned.
%
% RANGE defaults to all iterations.
%
% EXAMPLES:
%
% wl = wl_instance(obj, 1:iterations(obj));
%   - returns all instances of the weak learner
%
% wl = wl_instance(obj, iterations(obj));
%   - returns the last one
%

% @boost/wl_instance.m
% Jeremy Barnes, 6/8/1999
% $Id$

if (nargin == 1)
   range = 1:iterations(obj);
end

if (length(range) == 0)
   wl = [];

else
   for i=1:length(range)
      instance = range(i);
      wl(i) = obj.classifiers{instance};
   end
end

