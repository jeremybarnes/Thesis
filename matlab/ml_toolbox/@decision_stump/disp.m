function disp(obj)

% DISP method for DATASET object

% @decision_stump/disp.m
% Jeremy Barnes, 25/4/1999
% $Id$

s = size(obj);
if ((s(1) ~= 1) | (s(2) ~= 1))
   sizestr = ['(' int2str(s(1))];
   for i=2:length(s)
      sizestr = [sizestr ' x ' int2str(s(i))];
   end
   sizestr = [sizestr ')'];
   
   disp(['Array of decision stumps, size = ' sizestr])
else
   disp(['    decision stump object:']);
   disp(['      dimensions    = ' int2str(obj.dimensions)]);
   disp(['      categories    = ' int2str(numcategories(obj.categories))]);
   disp(['      splitvar      = ' int2str(obj.splitvar)]);
   disp(['      splitval      = ' num2str(obj.splitval)]);
   disp(['      leftcategory  = ' int2str(obj.leftcategory)]);
   disp(['      rightcategory = ' int2str(obj.rightcategory)]);
end

