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

% @normboost2/eval_cf.m
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

% Calculate margins
y = y_data*2-1;

margins = obj.margins + y .* results .* alpha;

% Evaluate sample costs
sample_costs = exp(-margins);

% Evaluate derivative of sample costs
d_sample_costs = -y .* results .* sample_costs;

% Second derivative of sample costs
d2_sample_costs = y.^2 .* results.^2 .* sample_costs;

% Add up to get totals
cost = sum(sample_costs);
dcost = sum(d_sample_costs);
d2cost = sum(d2_sample_costs); 





