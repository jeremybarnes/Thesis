function printtree(obj)

% FIXME comment

% @cart/printtree.m
% Jeremy Barnes, 6/4/1999
% $Id$

recursive_print(obj.tree, 0);

function recursive_print(tree, spaces)

sp = [];
for i=1:spaces
   sp = [sp ' '];
end

if (isa(tree, 'double'))
   % If it is a terminal node, print that
   disp([sp 'terminal: ' int2str(tree)]);
else
   % Otherwise, print the left and right subtrees
   disp([sp 'split on x' int2str(tree.splitvar) ' = ' ...
	 num2str(tree.splitval)]);
   disp([sp 'left:']);
   recursive_print(tree.left, spaces+4);
   disp([sp 'right:']);
   recursive_print(tree.right, spaces+4);
end




   
