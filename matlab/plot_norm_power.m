function plot_norm_power

% plot_norm_power.m
% Jeremy Barnes, 26/8/1999
% $Id$

% This generates a plot of the "normalising power" (see page 135 of my
% notebook) for different values of p.

gamma = logspace(-3, 2);

all_p = [0.5 1.0 2.0];
all_colors = 'brk';

figure(1);  clf;

for i=1:length(all_p)
   p = all_p(i);
   color = all_colors(i);
   
   norm_power = calc_norm_power(gamma, p);
   
   semilogx(gamma, norm_power, [color '-']);  hold on;
end

xlabel('gamma');
ylabel('norm power');
grid on;
legend('p=0.5', 'p=1.0', 'p=2.0', 0);
   
   


function norm_power = calc_norm_power(gamma, p)

norm_power = (1 + gamma.^p).^(-1./p);


