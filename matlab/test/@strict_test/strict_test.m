function obj = strict_test(weaklearner, norm)

% STRICT_TEST test class to evaluate training of strict (normboost)

% @test/strict_test/strict_test.m
% Jeremy Barnes, 16/10/1999
% $Id$

if ((nargin == 1) & (isa(weaklearner, 'strict_test')))
   % One parameter --> make a copy
   obj = weaklearner;
   return
end

if (nargin == 0)
   % Zero parameters: choose defaults
   parent = normboost;
else
   parent = normboost(weaklearner, norm);
end

obj.dummy = 1; % Dummy field to stop complaints
obj.margins = []; % Replaced when we know what our training data is

% construct class and define superior/inferior relationship
obj = class(obj, 'strict_test', parent);
superiorto('double', 'classifier', 'boost', 'normboost');

