function [cost, dcost, d2cost, margins] = eval_cf(obj, f, alpha)

% EVAL_CF evaluate boosting cost function
%
% SYNTAX:
%
% [cost, dcost, d2cost, marg] = eval_cf(obj)
% [cost, dcost, d2cost, marg] = eval_cf(obj, f, alpha)
%
% The first variant calculates the cost function over all training
% samples of obj, returning the total cost.  It is used to evaluate the
% cost function of the current classifier.
%
% The second variant calculates the cost function of the hypothesis given
% by H = beta * F + alpha * f, where F is the classifier in obj, and f is
% another weaklearner.
%
% RETURNS:
%
% COST is the cost function evaluated at the point.
%
% DCOST is the derivative of the cost function at the point.
%
% D2COST is the second derivative of the cost function at the point.
%
% MARG are the margins of H.

% @normboost/eval_cf_deriv.m
% Jeremy Barnes, 17/8/1999
% $Id$

% Fill in parameters
if (nargin == 1)
   f = [];
   alpha = 0;
end

x_data = x(obj);
y_data = y(obj);

% Find out how the new classifier classified them
if (~isempty(f))
   results = classify(f, x_data)*2 - 1;
else
   results = ones(size(y_data));
end

y = y_data*2-1;

% a = alpha, just to save typing
a = alpha;
p = norm(obj);

% This factor normalises to ||b||p = 1
normfac = (1 + a.^p).^(1/p);

% Calculate margins
margins = (obj.margins + y .* results .* a) / normfac;

% Evaluate sample costs
sample_costs = exp(-margins);

% Derivative of sample costs
factor_1 = ((obj.margins + y.*results.*a).*a.^p) ./ ...
    (normfac .* a .* (1 + a.^p));
factor_2 = (y.*results) ./ normfac;
d_sample_costs = (factor_1 - factor_2) .* sample_costs;

% Second derivative
% NOTE: This code is obtained from MAPLE's 'C' command (viz:)
% cost := ...
% >> readlib(C);
% >> d2cost = diff(cost, a$2);
% >> C(d2cost, optimized);
% Note also that you have to replace "pow" with "power", replace "*" with
% ".*", and put in obj.margins for y*F(x[i]) and results for f(x[i]).

t1 = power(a,p);
t2 = 1.0+t1;
t4 = power(t2,1/p);
t6 = 1/t4;
t8 = results;
t11 = t6.*(obj.margins+y.*a.*t8);
t12 = t1.*t1;
t13 = a.*a;
t14 = 1/t13;
t15 = t12.*t14;
t16 = t2.*t2;
t17 = 1/t16;
t20 = t6.*y.*t8;
t23 = 1/t2;
t24 = t1/a.*t23;
t37 = exp(-t11);
t41 = power(t11.*t24-t20,2.0);
t43 = (-t11.*t15.*t17+2.0.*t20.*t24+t11.*t1.*p.*t14.*t23-t11.*t1.*t14.* ...
       t23-t11.*t15.*t17.*p).*t37+t41.*t37;
d2_sample_costs = t43;

% Add up to get totals
cost = sum(sample_costs);
dcost = sum(d_sample_costs);
d2cost = sum(d2_sample_costs); 
