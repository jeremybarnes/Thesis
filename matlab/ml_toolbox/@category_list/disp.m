function disp(obj)

% DISP display a CATEGORY_LIST object

% @category_list/disp.m
% Jeremy Barnes, 4/4/1999
% $Id$

for i=0:obj.numcategories-1
   if (i == 0)
      mystr = ['"' categorynum(obj, i) '"'];
   else
      mystr = [mystr ', "' categorynum(obj, i) '"'];
   end
end

disp(['   category_list(' mystr ')']);


