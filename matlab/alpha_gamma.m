function alpha_gamma

% alpha_gamma.m
% Jeremy Barnes, 25/8/1999
% $Id$

% This generates a plot of alpha vs gamma for different values of p.
% See my notebook, page 129

gamma = logspace(-2, 3);

all_p = [0.5 1.0 2.0];
all_colors = 'brk';

figure(1);  clf;

for i=1:length(all_p)
   p = all_p(i);
   color = all_colors(i);
   
   alpha = calc_alpha(gamma, p);
   
   semilogx(gamma, alpha, [color '-']);  hold on;
end

xlabel('gamma');
ylabel('alpha');
grid on;
legend('p=0.5', 'p=1.0', 'p=2.0', 0);
   
   


function alpha = calc_alpha(gamma, p)

alpha = gamma ./ (1 + gamma.^p).^(1/p);

