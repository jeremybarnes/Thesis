function newtree = recursive_prune(obj, tree, x, y, w, lambda)

% RECURSIVE_PRUNE prune a CART tree to obtain a simpler classifier
%
% This function prunes the tree that was generated using the
% RECURSIVE_TRAIN function, in order to generate a simpler tree that
% still performs nearly as well as the original tree.
%
% This is done by trading off between tree complexity and generalisation
% error.  
%
% NOTE: obj is not used, it is only here to make sure that the correct
% recursive_train routine gets called.
%
% NOTE: this code is in a separate M-file so that it can be implemented
% in high-speed C code in an external MEX file.
%
% The specifics: 
%
% The pruning algorithm minimises the model selection criteria which is
% a penalised form of the misclassification risk, given by
%
% Rpen = Remp + lambda * T
%
% where Rpen is the model selection criteria, lambda is a parameter which
% controls how aggresively the model complexity is traded off against
% training error, and the T is the size of the tree (number of terminal
% nodes).
%
% Lambda is generally chosen by resampling techniques on the training
% data.  However, in this routine it is simply a parameter (its optimal
% value will need to be determined elsewhere).
%
% The change in the model selection criteria that would be a result of
% converting a particular node into a terminal node can be calculated
% using just the information at the node as
%
% delta_Rpen = delta_Remp + lambda * delta_T
%
% The pruning routine works by the following algorithm:
%
% REPEAT
%
%   FOREACH nonterminal node in the tree
%      calculate delta_Rpen for this node
%
%   IF min(delta_Rpen) < 0
%   THEN convert this node into a non-terminal
%
% UNTIL min(delta_Rpen >= 0)

% NOTE: I have not actually implemented this code, for the following
% reasons:
%
% * Currently, I am not sure of exactly how to implement the resampling
%   procedure in a reasonably efficient manner.
%
% * Consequently, I would not be able to determine the best value for
%   lambda.
%
% * Thus, I would most likely set lambda to zero anyhow.
%
% * Which does exactly nothing.

% @cart/recursive_prune.m
% Jeremy Barnes, 17/5/1999
% $Id$

obj = cart(obj);

newtree = tree; % Temporary, until I get around to implementing it.

