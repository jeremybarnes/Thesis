function obj_r = abort(obj)

% ABORT cause a boost object to abort training
%
% SYNTAX:
%
% obj_r = abort(obj)
%
% FIXME: comment

% @boost/abort.m
% Jeremy Barnes, 17/8/1999
% $Id$

obj.aborted = 1;
obj_r = obj;
