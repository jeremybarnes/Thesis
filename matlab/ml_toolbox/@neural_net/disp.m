function disp(obj)

% DISP method for NEURAL_NET object

% @neural_net/disp.m
% Jeremy Barnes, 2/10/1999
% $Id$

disp(['  neural_net object:']);
disp_info(obj.classifier, 'inherited');
disp(['    --- neural_net fields:']);
disp_info(obj);


