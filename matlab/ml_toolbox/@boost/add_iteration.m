function obj_r = add_iteration(obj, new_c, new_b, new_w)

% ADD_ITERATION move the boosting algorithm on another iteration
%
% FIXME: comment

% @boost/add_iteration.m
% Jeremy Barnes, 17/8/1999
% $Id$

i = iterations(obj) + 1;

if (~obj.nosave)
   obj.classifiers{i} = new_c;
end

obj.b = new_b;
obj.w = new_w;
obj.iterations = i;

obj_r = obj;