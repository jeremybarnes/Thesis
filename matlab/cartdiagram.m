% CARTDIAGRAM generate a diagram to describe CART
%
% SYNTAX:
%
% cartdiagram

% cartdiagram.m
% Jeremy Barnes, 11/7/1999
% $Id$

figure(1);  clf;
   
for i=1:2

	b = category_list('binary');
	d = dataset(b, 2);
	d = datagen(d, 'ring', 20, 0, 0);

	s = cart(b, 2, 'gini', 4);
	s = train(s, d)

   subplot(1, 2, i);
   plotboundary(s, [1 1; 0 0]);
	hold on;
	dataplot(d);
   
   xlabel('x_1');
   ylabel('x_2');
   
   if (i==1)
      title('(a)');
   else
      title('(b)');
   end
end

set(1, 'paperposition', [0 0 7 3]);
print -depsc -f1 cartdiagram.eps



