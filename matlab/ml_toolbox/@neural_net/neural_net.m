function obj = neural_net(hidden, dimensions, numcategories)

% NEURAL_NET classifier based upon a neural network
%
% This is the constructor.
%
% This class encapsulates a two-layer perceptron neural network
% classifier.
%
% The number of input units is equal to DIMENSIONS.  There are HIDDEN
% nodes in the hidden layer.  CATEGORIES is a CATEGORY_LIST object.
%
% The network is constructed with one output node for each possible
% class.
%
% RETURNS:
% OBJ is the new boost object.
%

% @neural_net/neural_net.m
% Jeremy Barnes, 2/10/1999
% $Id$

% Neural net first argument --> return a copy
if ((nargin == 1) & (isa(hidden, 'neural_net')))
   obj = hidden;
   return
elseif (nargin == 2)
   numcategories = 2;
elseif (nargin == 1)
   numcategories = 2;
   dimensions = 2;
elseif (nargin == 0)
   hidden = 10;
   categories = 2;
   dimensions = 2;
end

parent = classifier(numcategories, dimensions);

% Save our parameters
obj.hidden_units = hidden; 

% Hidden layer weights: row = input, col = hidden unit, start off random
obj.w_hidden = rand(dimensions+1, hidden) * 0.05;

% Output weights: row = hidden unit, col = output, start off random
obj.w_out = rand(hidden+1, numcategories) * 0.05;

% Options and parameters
obj.eta = 0.3;        % Learning rate
obj.alpha = 0;        % Momentum; off by default

obj.iterations = 0;   % Number of training iterations performed

% Here is the training data.  Not required if we specify data directly to
% the train method or we use a stochastic (single sample update) method.
obj.x = [];  % samples (x)
obj.y = [];  % labels (y)

obj.trainmethod = 'stochastic'; % or 'pure' to use the pure versino
obj.samplenumber = 1; % which sample we are up to for stochastic
obj.progressinterval = 100; % How often to print out training progress

% This data is required to implement momentum
obj.last_update_o = zeros(size(obj.w_out));
obj.last_update_h = zeros(size(obj.w_hidden));

% construct class and define superior/inferior relationship
obj = class(obj, 'neural_net', parent);
superiorto('double', 'classifier');
