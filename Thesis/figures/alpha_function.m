function alpha_function

% alpha_function.m
% Jeremy Barnes, 16/10/1999
% $Id$


global EPSFILENAME


alpha = logspace(-2, 2, 101);

figure(1);  clf;  

allp = [0.5 1.0 2];
styles = {'--', '-', '-'};
linewidths = {1, 2, 1};

for i=1:length(allp)

   p = allp(i);
   
   cww = calc_cost(alpha, -1, -1, p);
   cwr = calc_cost(alpha, -1,  1, p);
   crw = calc_cost(alpha,  1, -1, p);
   crr = calc_cost(alpha,  1,  1, p);
      
   style = ['k' styles{i}];
   
   lw = linewidths{i};
   
   subplot(1, 4, 1);  setup_axis;
   semilogx(alpha, cww, style, 'linewidth', lw);
   title('(a) \sl{(wrong, wrong)}');  grid on;  hold on;
   axis square;  xlabel('\alpha');  ylabel('Sample cost \it{c}');
   
   subplot(1, 4, 2);  setup_axis;
   semilogx(alpha, cwr, style, 'linewidth', lw);
   title('(b) \sl{(wrong, right)}');  grid on;  hold on;
   axis square;  xlabel('\alpha');
   
   subplot(1, 4, 3);  setup_axis;
   semilogx(alpha, crw, style, 'linewidth', lw);
   title('(c) \sl{(right, wrong)}');  grid on;  hold on;
   axis square;  xlabel('\alpha');
   
   subplot(1, 4, 4);  setup_axis;
   semilogx(alpha, crr, style, 'linewidth', lw);
   title('(d) \sl{(right, right)}');  grid on;  hold on;
   axis square;  xlabel('\alpha');
end


set(1, 'paperposition', [0 0 6 2.5]);

print(EPSFILENAME, '-f1','-deps2');





function c = calc_cost(alpha, oldm, newm, p)

c = exp((-oldm - (newm.*alpha)) ./ ((1 + alpha.^p).^(1./p)));
