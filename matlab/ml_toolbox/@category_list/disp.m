function disp(obj)
% DISP display a classlabel object
% @classlabel/disp.m
% Jeremy Barnes, 4/4/1999
% $Id$

disp(['    classlabel object:']);
disp(['      numlabels = ' int2str(obj.numlabels)]);

for i=0:obj.numlabels-1
   if (i == 0)
      mystr = ['"' labelnum(obj, i) '"'];
   else
      mystr = [mystr ', "' labelnum(obj, i) '"'];
   end
end

disp(['      labels = {' mystr '}']);


