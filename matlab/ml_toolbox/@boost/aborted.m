function a = aborted(obj)

% ABORTED true if training has finished

% @boost/aborted.m
% Jeremy Barnes, 25/4/1999
% $Id$

obj = boost(obj);
a = obj.aborted;