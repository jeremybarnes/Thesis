function new_margins = update_margins(obj, old_margins, wl_y, context)

% UPDATE_MARGINS update a margin distribution in response to training
%
% This private internal function updates a set of margins to reflect a
% new iteration of training.  The iteration is assumed to be the previous
% one.
%
% CONTEXT is there to provide context for this iteration, if nosave is
% on.

% @boost/private/update_margins.m
% Jeremy Barnes, 22/9/1999
% $Id$

% In the case of boosting, we simply add on b_t if wl_y = 1, and subtract
% b_t if wl_y = 0.

b_t = context.bt;

% Transform 0,1 into -1,1
wl_y = 2*wl_y - 1;

new_margins = old_margins + b_t * wl_y;
