function [obj_r, context] = trainagain(obj)

% TRAINAGAIN perform another training iteration of the boosting algorithm
%
% SYNTAX:
%
% obj_r = trainagain(obj)
%
% Performs supervised training on the classifier using either the dataset
% {X, Y} or the dataset DATASET.  If specified, the weight vector W is
% used to determine the initial relative importance of each training
% sample in the dataset.
%
% [obj_r, context] = trainagain(obj)
%
% This form returns information designed to make the testing process more
% efficient.  It is a struct array, with (at least) the fields 
%
% RETURNS:
%
% A classifier that has had one more iteration of "boosting" performed on it

% @normboost/trainagain.m
% Jeremy Barnes, 17/8/1999
% $Id$

if (aborted(obj))
   obj_r = obj;
   warning('trainagain: attempt to train when training aborted');
   return;
end

global DEBUG_TRAIN;

if (isempty(DEBUG_TRAIN))
   DEBUG_TRAIN = 0;
end

x_data = x(obj);  y_data = y(obj);  w_data = w(obj);  p = norm(obj);

% create and train a new classifier
new_c = train(weaklearner(obj), x_data, y_data, w_data);

% find the training error
new_error = training_error(new_c);

% see what this algorithm does to our data
new_y = classify(new_c, x_data);


% find if we need to abort
if (new_error == 0)
   % Zero error -- one classifier can do perfectly by itself
   obj_r = abort(obj);
   return;
end

if (new_error >= 0.5)
   % Error of 0.5 -- random guessing does just as well
   obj_r = abort(obj);
   return;
end

if ((DEBUG_TRAIN > 1) & (iterations(obj) == 0))
   figure(1);  clf;
end

% Calculate alpha

if (iterations(obj) == 0)
   % First iteration -- set alpha to 1 and marg to the margins of the
   % trained weak learner.

   alpha = 1.0;
   marg = (y_data*2-1) .* (new_y*2-1);
   new_b = [1.0];

else
   % Calculate alpha using a line search.  This uses the Newton-Raphson method
   % to find the minimum.

   if (DEBUG_TRAIN == 1)
      % DEBUGGING CODE -- draw a graph so that we can follow the progress

      alphas = linspace(0.01, 0.5);
      all_c = zeros(size(alphas));
      all_d = zeros(size(alphas));
      all_d2 = zeros(size(alphas));
      
      for i=1:length(alphas)
	 [all_c(i), all_d(i), all_d2(i), crap] = eval_cf(obj, new_c, ...
							 alphas(i));
      end
      
      % Calculate numerically to test that we got them right...
      calc_alpha = (alphas(1:length(alphas)-1) + alphas(2:length(alphas))) / 2;
      calc_d = diff(all_c) ./ diff(alphas);
      calc_alpha2 = (calc_alpha(1:length(calc_alpha)-1) + ...
		     calc_alpha(2:length(calc_alpha))) / 2;
      calc_d2 = diff(calc_d) ./ diff(calc_alpha);
      
      figure(1);  clf;
      subplot(3, 1, 1);  plot(alphas, all_c);   grid on;  hold on;
      subplot(3, 1, 2);  plot(alphas, all_d);   grid on;  hold on;
      plot(calc_alpha, calc_d, 'k-');
      subplot(3, 1, 3);  plot(alphas, all_d2);  grid on;  hold on;
      plot(calc_alpha2, calc_d2, 'k-');
      
      % END DEBUGGING
   elseif ((DEBUG_TRAIN > 1) & (iterations(obj)-1 <= DEBUG_TRAIN)) 
      % DEBUGGING
      % Draw DEBUG_TRAIN plots of the minimisation of the first
      % DEBUG_TRAIN iterations

      alphas = logspace(-5, 1, 100);
      all_c = zeros(size(alphas));
      all_d = zeros(size(alphas));
      all_d2 = zeros(size(alphas));
      
      for i=1:length(alphas)
	 [all_c(i), all_d(i), all_d2(i), crap] = eval_cf(obj, new_c, ...
							 alphas(i));
      end

      subplot(DEBUG_TRAIN, 1, iterations(obj));
      semilogx(alphas, all_c);  grid on;  hold on;

      obj.margins
      % END DEBUGGING
   end
   
   % Initialisation
   new_alpha = 0.5 / iterations(obj);
   d = 1;
   min_d = inf;
   max_d = -inf;
   last_c = 1000000;
   tolerance = 0.001;
   
   
   % Iterate

   iter = 0;
   while ((abs(d) >= tolerance) & (iter < 1000))
      alpha = new_alpha;
      
      [c, d, d2] = eval_cf(obj, new_c, alpha);
      min_d = min([d min_d]);
      max_d = max([d max_d]);
      
      if (DEBUG_TRAIN == 1)
	 % DEBUGGING
	 
	 c
	 d
	 d2
	 
	 subplot(3, 1, 1);  plot(alpha, c, 'rx');
	 subplot(3, 1, 2);  plot(alpha, d, 'rx');
	 subplot(3, 1, 3);  plot(alpha, d2, 'rx');
	 
	 % END DEBUGGING
      elseif ((DEBUG_TRAIN > 1) & (iterations(obj)-1 <= DEBUG_TRAIN))
	 semilogx(alpha, c, 'rx');
      end
      
      % Handle d2=0 in a very crude manner, which allows us to continue
      if (d2 < eps)
	 d2 = 0.01;
      end
      
      new_alpha = alpha - (d / d2);
      
      % Never let alpha move more than half the distance to zero.  This
      % can lead to alpha < zero, which causes all kinds of problems.
      min_alpha = alpha / 2;
      new_alpha = max([min_alpha new_alpha]);
      
      % This stopping rule is designed to detect the situation where there
      % is no solution as dc/dalpha > 0 for all alpha.  It halts the
      % training if there is no change in the cost function, and we have
      % not found a zero crossing of the derivative.
      if ((abs(c - last_c) < tolerance) & (min_d*max_d > 0))
	 break;
      end
      last_c = c;
      
      if (DEBUG_TRAIN)
	 new_alpha
	 pause;
      end
   
      iter = iter + 1;
   end

   % FIXME: Do we need alpha = new_alpha here?
   
   % Test for lack of convergence
   if (iter >= 100)
      warning('trainagain: failed to converge after 100 iterations');
   end
   
   % Test for minimum/maximum at our found point.  We do this on the sign
   % of the second derivative: if positive, we found a minimum; if
   % negative we found a maximum.
   [c, d, d2, marg] = eval_cf(obj, new_c, alpha);
   
   if (d2 <= 0.0)
      alpha = 0;
      obj = abort(obj);
   end
   
   
   old_b = classifier_weights(obj);
   new_b = [old_b alpha] ./ pnorm([old_b alpha], p);

%   one_norm = pnorm(new_b, 1)
end

% Update the sample weights.  These are calculated as the derivatives
% of the cost _function_ (not functional) and then normalised with a
% 1-norm equal to 1.
%
% For a cost function of exp(-x), dc/dx = -exp(-x).  The minus gets
% normalised out, and can be ignored.

new_w = exp(-marg);
new_w = new_w ./ sum(new_w);


% Update our weights
obj = add_iteration(obj, new_c, new_b, new_w);
obj.margins = marg;

obj_r = obj;

context.wl_y = new_y;
context.wl_instance = new_c;
context.b = new_b;
context.alpha = alpha;
context.first_iter = (iterations(obj) == 1);
