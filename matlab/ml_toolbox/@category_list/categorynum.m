% @classlabel/labelnum.m
% Jeremy Barnes, 3/4/1999
% $Id$
%
% SYNTAX:
%
% 'label' = labelnum(obj, n)
%
% RETURNS:
%
% Label number n from the classlabel object.  Note that labels are
% indexed from 0 (this is in order to make porting to C easier).
%
% Out of range values of n cause an error.
%

function label = labelnum(obj, n)

% PRECONDITIONS
if ((n < 0) | (n > numlabels(obj)-1))
   error('labelnum: index n is out of range');
end


label = obj.labels{n+1};

% POSTCONDITIONS
global_postconditions(obj);

return;
