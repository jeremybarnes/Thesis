function cost = eval_cf(obj, beta, f, alpha)

% EVAL_CF evaluate boosting cost function
%
% SYNTAX:
%
% cost = eval_cf(obj)
% cost = eval_cf(obj, beta, f, alpha)
%
% The first variant calculates the cost function over all training
% samples of obj, returning the total cost.  It is used to evaluate the
% cost function of the current classifier.
%
% The second variant calculates the cost function of the hypothesis given
% by H = beta * F + alpha * f, where F is the classifier in obj, and f is
% another weaklearner.

% Fill in parameters
if (nargin == 1)
   beta = 1;
   f = [];
   alpha = 0;
end

% Find out how the new classifier classified them
if (~isempty(f))
   results = classify(f, obj.x)*2 - 1;
else
   results = ones(size(obj.y));
end

% Calculate total margins
total_margins = beta .* obj.margins + (obj.y*2-1) .* results .* alpha;

% Evaluate cost function
cost = sum(exp(-total_margins));

% Simple, huh!




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

% Find out how the new classifier classified them
if (~isempty(f))
   results = classify(f, obj.x)*2 - 1;
else
   results = ones(size(obj.y));
end

% Use the variables a and b (obtained from alpha) to make our formula
% simpler to write (see notebook, page 116 for more details).
p = obj.p;
beta = (1 - alpha.^p).^(1/p)
a = alpha .^ p;
b = 1 - a;

% Calculate margins
y = obj.y*2-1;
margins = beta .* obj.margins + y .* results .* alpha;

% Evaluate sample costs
sample_costs = exp(-total_margins);

% Evaluate derivative of sample costs
d_sample_costs = (b.^(1/p - 1) .* obj.margins ...
		  - y .* results .* a.^(1/p-1)) ...
                 .* sample_costs;

% Second derivative of sample costs
d2_sample_costs = (b.^(1/p - 2) .* (p*(1 + b) - 1) .* obj.margins ...
		   + a.^(1/p - 2) .* (p*(1 - a) - 1) .* y .* results) ...
                  .* sample_costs;

% Add up to get totals
cost = sum(sample_costs);
dcost = sum(d_sample_costs);
d2cost = sum(d2_sample_costs); 





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

% Use the variables a and b (obtained from alpha) to make our formula
% simpler to write (see notebook, page 116 for more details).
p = obj.p;
beta = (1 - alpha.^p).^(1/p)
a = alpha .^ p;
b = 1 - a;

% Calculate margins
y = y_data*2-1;

margins = beta .* obj.margins + y .* results .* alpha;

% Evaluate sample costs
sample_costs = exp(-margins);

% Evaluate derivative of sample costs
d_sample_costs = (b.^(1/p - 1) .* obj.margins ...
		  - y .* results .* a.^(1/p-1)) ...
                 .* sample_costs;

% Second derivative of sample costs
d2_sample_costs = (b.^(1/p - 2) .* (p*(1 + b) - 1) .* obj.margins ...
		   + a.^(1/p - 2) .* (p*(1 - a) - 1) .* y .* results) ...
                  .* sample_costs;

% Add up to get totals
cost = sum(sample_costs);
dcost = sum(d_sample_costs);
d2cost = sum(d2_sample_costs); 





