function label = categorynum(obj, n)

% CATEGORYNUM return a particular category label
%
% SYNTAX:
%
% 'label' = labelnum(obj, n)
%
% RETURNS:
%
% Label number N from the category_list object OBJ.  Note that labels are
% indexed from 0 (this is in order to make porting to C easier).
%

% @category_list/categorynum.m
% Jeremy Barnes, 3/4/1999
% $Id$


% PRECONDITIONS
if ((n < 0) | (n > numlabels(obj)-1))
   error('labelnum: index n is out of range');
end


label = obj.labels{n+1};


% POSTCONDITIONS
check_invariants(obj);
