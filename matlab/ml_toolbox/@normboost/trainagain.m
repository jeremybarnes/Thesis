function obj_r = trainagain(obj)

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
% RETURNS:
%
% A classifier that has had one more iteration of "boosting" performed on it

% @normboost/trainagain.m
% Jeremy Barnes, 17/8/1999
% $Id$

if (aborted(obj))
   obj_r = obj;
   warning('trainagain: attempt to train when training is aborted');
   return;
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


% Calculate alpha

if (iterations(obj) == 0)
   % First iteration -- set alpha to 1 and marg to the margins of the
   % trained weak learner.

   alpha = 1.0;
   marg = (y_data*2-1) .* (new_y*2-1);
   new_b = [1.0];

else
   % Calculate b_t using a line search.  This uses the Newton-Raphson method
   % to find the minimum.

   % DEBUGGING CODE -- draw a graph so that we can follow the progress

   alphas = linspace(0.01, 0.99);
   all_c = zeros(size(alphas));
   all_d = zeros(size(alphas));
   all_d2 = zeros(size(alphas));

   for i=1:length(alphas)
      [all_c(i), all_d(i), all_d2(i), crap] = eval_cf(obj, new_c, ...
						      alphas(i));
   end
   
   figure(1);  clf;
   subplot(3, 1, 1);  plot(alphas, all_c);   grid on;  hold on;
   subplot(3, 1, 2);  plot(alphas, all_d);   grid on;  hold on;
   subplot(3, 1, 3);  plot(alphas, all_d2);  grid on;  hold on;

   % END DEBUGGING

   % Initialisation
   new_alpha = 0.5 / iterations(obj);
   d = 1;

   % Iterate

   while (abs(d) >= 0.001)
      alpha = new_alpha;
      
      [c, d, d2, marg] = eval_cf(obj, new_c, alpha)

      % DEBUGGING
      
      subplot(3, 1, 1);  plot(alpha, c, 'rx');
      subplot(3, 1, 2);  plot(alpha, d, 'rx');
      subplot(3, 1, 3);  plot(alpha, d2, 'rx');
      
      % END DEBUGGING

      % FIXME: need to gracefully handle d2 = 0
      
      new_alpha = alpha - (d / d2)

      pause;
   end

   old_b = classifier_weights(obj);
   new_b = [(1 - alpha.^p).^(1/p) * old_b alpha];
   pnorm(new_b, p)

end


% Update the sample weights.  These are calculated as the derivatives
% of the cost _function_ (not functional) and then normalised with a
% 1-norm equal to 1.
%
% For a cost function of exp(-x), dc/dx = -exp(-x).  The minus gets
% normalised out, and can be ignored.

new_w = exp(-marg);
new_w = new_w ./ sum(new_w);


% Update our boosting algorithm
obj = add_iteration(obj, new_c, new_b, new_w);
obj.margins = marg;

obj_r = obj;
