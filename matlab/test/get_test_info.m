function info = get_test_info(test)

% GET_TEST_INFO return information about a test
%
% SYNTAX:
%
% info = get_test_info('test');
%
% RETURNS:
%
% Info is a structure array containing the following fields:
%
% exists          - the test
% iterations      - iterations used in the test
% name            - name of the test
% type            - type of test ('testtrain', 'peffect')
% p               - p values used in the test 
% noise           - noise values used in the test

% get_test_info.m
% Jeremy Barnes, 9/10/1999
% $Id$


% Try to load up our summary file

global DATA_SAVE_PATH;

if (isempty(DATA_SAVE_PATH))
   error(['get_test_info: must set global variable DATA_SAVE_PATH before' ...
	  'you begin']);
end

% Summary file name
summaryfile = [DATA_SAVE_PATH '/' test '-summary.mat'];

% Try to load in the 'noise' and 'p' records
load_error = 0;
eval('load(summaryfile, ''name'', ''numiterations'', ''noise'', ''p'');', ...
     'load_error = 1;'); 

% If we can't load it, it doesn't exist
if (load_error)
   info.exists = 0;
   return;
end

info.exists = 1;
info.numiterations = numiterations;
info.noise = noise;
info.p = p;
info.type = 'testtrain';

