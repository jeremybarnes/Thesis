function pboost_weight_test(p)

% PBOOST_WEIGHT_TEST test if new scheme for p-boost weight distribution
% is equivalent to old scheme

% pboost_weight_test.m
% Jeremy Barnes, 1/8/1999
% $Id$

new_bvalues = [];
old_bvalues = [];
sigma = 1;
iteration = 1;

while (1) 
   % get b value
   b = input(['Enter b value for iteration ' num2str(iteration) ': ']);
   
   
   
   % Old method: add it to old_bvalue, then print out normalised old_bvalues
   disp('Old method:');
   old_bvalues = [old_bvalues b];
   
   old_bvalues2 = old_bvalues ./ pnorm(old_bvalues, p)
   
   pnorm(old_bvalues2, p)
   
   
   
   % New method: update automatically
   disp('New method:');
   
   if (iteration == 1)
      new_bvalues = 1;
      sigma = 1/b;
   else
      delta = sigma * b;
      alpha = (1 / (1 + delta.^p)) .^ (1/p)
      beta = (1 / (1 + delta.^(-p))) .^ (1/p)
      
      new_bvalues = [new_bvalues * alpha   beta]
      sigma = sigma * alpha;
   end
   
	iteration = iteration + 1;   
end



function n = pnorm(vec, p)

% PNORM calculate the p-norm of a vector

n = sum(vec .^ p) .^ (1/p);

