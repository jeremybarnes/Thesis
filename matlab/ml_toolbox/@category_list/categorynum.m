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

% @category_list/categorynum.m
% Jeremy Barnes, 3/4/1999
% $Id$

label = obj.categories{n+1};
