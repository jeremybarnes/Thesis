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

if (tree.isterminal)
   % If it is a terminal node, print that
   disp([sp 'terminal: ' int2str(tree.category)]);
   print_info(tree, sp);
else
   % Otherwise, print the left and right subtrees
   disp([sp 'split on x' int2str(tree.splitvar) ' = ' ...
	 num2str(tree.splitval)]);
   print_info(tree, sp);
   disp([sp 'left:']);
   recursive_print(tree.left, spaces+4);
   disp([sp 'right:']);
   recursive_print(tree.right, spaces+4);
end








function print_info(tree, sp)

% PRINT_INFO print information about a tree

disp([sp '  numsamples:  ' int2str(tree.numsamples) '  (' ...
      num2str(tree.numcorrect ./ tree.numsamples .* 100) ...
      '% correct)']);

disp([sp '  totalweight: ' num2str(tree.totalweight) '  (' ...
      num2str(tree.correctweight ./ tree.totalweight .* 100) ...
      '% correct)']);




   
