function printtree(obj)

% PRINTTREE print out a textual representation of a CART tree
%
% SYNTAX:
%
% printtree(obj)
%
% This function traverses the decision tree and prints out information
% about the variable split on, the value of that variable, and the
% categories of terminal nodes.  Subordinate nodes are indented with
% spaces.
%
% It also displays information about the performance of the classifier on
% the training data.
%
% This is a complete set of information about the tree.
%
% (It "prints" to the console, not the printer, by the way...)

% @cart/printtree.m
% Jeremy Barnes, 6/4/1999
% $Id$

% Do it recursively...
obj = cart(obj);
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




   
