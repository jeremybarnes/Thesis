function i = iterations(obj)

% ITERATIONS return the number of boosting iterations
%
% SYNTAX:
%
% iter = iterations(obj)
%
% RETURNS:
%
% ITER is the number of iterations that OBJ has been trained for.  This
% starts out at zero for a newly-created object, and is increased by one
% with every call to trainagain.

% @boost/iterations.m
% Jeremy Barnes, 25/8/1999
% $Id$

i = obj.iterations;