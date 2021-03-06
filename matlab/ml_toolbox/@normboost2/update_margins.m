function new_margins = update_margins(obj, old_margins, wl_y, context)

% UPDATE_MARGINS update a margin distribution in response to training
%
% This private internal function updates a set of margins to reflect a
% new iteration of training.  The iteration is assumed to be the previous
% one.
%
% CONTEXT is there to provide context for this iteration, if nosave is
% on.

% @normboost2/update_margins.m
% Jeremy Barnes, 22/9/1999
% $Id$

% Several things happen to our margins here.  Firstly, we divide by
% (1 + alpha^p) ^ (1/p).  We then add on alpha if wl_y = 1, or subtract
% alpha if wl_y = 0.

alpha = context.alpha;
p = norm(obj);

% Transform (0,1) into (-1,1)
wl_y = 2*wl_y - 1;

% The margins update differently on the first iteration to the rest, as
% there is no way we can optimise (we have a flat cost function).
if (context.first_iter)
   new_margins = wl_y;
else
   new_margins = (old_margins + (alpha * wl_y)) ./ ...
       (1 + alpha.^p).^(1/p);
end

