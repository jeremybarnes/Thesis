function gamma_function

% gamma_function.m
% Jeremy Barnes, 16/10/1999
% $Id$

gamma = logspace(-2, 2, 101);

figure(1);  clf;

allp = [0.5 0.75 1.0 1.5];
margw = [-1 -0.5 0];
margr = [1 0.5 0];
colors = {'r', 'b', 'k', 'g'};
styles = {':', '--', '-'};

for i=1:length(allp)

   p = allp(i);
   style = [colors{i} '-'];
   
   for j=1:length(margw)
      cwr = calc_cost(gamma, -1, 1, p);
      crr = calc_cost(gamma, -1, -1, p);
      crw = calc_cost(gamma, 1, -1, p);
      cww = calc_cost(gamma, 1, 1, p);
      
      subplot(2, 2, 1);
      semilogx(gamma, cww, style);  title('Wrong -> wrong');  grid on;  hold on;
      
      subplot(2, 2, 2);
      semilogx(gamma, cwr, style);  title('Wrong -> right');  grid on;  hold on;
      
      subplot(2, 2, 3);
      semilogx(gamma, crw, style);  title('Right -> wrong');  grid on;  hold on;
      
      subplot(2, 2, 4);
      semilogx(gamma, crr, style);  title('Right -> right');  grid on; ...
	    hold on;
   end
end





function c = calc_cost(gamma, gammasign, marg, p)

c = exp((marg + (gammasign.*gamma)) ./ ((1 + gamma.^p).^(1./p)));
