function alpha_function_sum

% alpha_function.m
% Jeremy Barnes, 16/10/1999
% $Id$


global EPSFILENAME


alpha = logspace(-4, 4, 101);

figure(1);  clf;  setup_figure;

allp = [0.5 1.0 2];
styles = {'--', '-', '-'};
linewidths = {1, 2, 1};

for i=1:length(allp)

   p = allp(i);
   
   cww = calc_cost(alpha, -1, -1, p);
   cwr = calc_cost(alpha, -1,  1, p);
   crw = calc_cost(alpha,  1, -1, p);
   crr = calc_cost(alpha,  1,  1, p);

   ctot = 7*crr + cwr + 2*crw;
   
   style = ['k' styles{i}];
   
   lw = linewidths{i};
   
   semilogx(alpha, ctot, style, 'linewidth', lw);
   title('(e) \sl{Cost functional for example}');
   grid on;  hold on; 
   axis square;  xlabel('\alpha');  ylabel('Total cost \it{C}');
end


set(1, 'paperposition', [0 0 4 2]);

print(EPSFILENAME, '-f1','-deps2');





function c = calc_cost(alpha, oldm, newm, p)

c = exp((-oldm - (newm.*alpha)) ./ ((1 + alpha.^p).^(1./p)));
