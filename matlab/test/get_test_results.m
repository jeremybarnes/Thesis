function results = get_test_results(test, type, noisevalues, pvalues)

% GET_RESULTS extract the results from a particular test summary
%
% SYTNAX:
%
% [...] = get_results('test', 'type', noisevalues, pvalues)
%
% This function extracts test results from a summary file.  TEST is the
% name of the test--this is used to determine which file to read from.
%
% TYPE is the type of results that are required.  If i is the number of
% iterations and t is the number of trials, then this may be one of:
%
%   'train_mean' - (i) mean training error values
%   'train_std'  - (i) standard deviation of training values
%   'test_mean'  - (i) mean testing error values
%   'test_std'   - (i) standard devation of testing error values
%   'counts'     - (i) number of trials that made it to each iteration
%   'best_err'   - (t) best error value for each trial
%   'best_iter'  - (t) training iteration on which best_err occured
%
% The number in the brackets is the size of the _third_ dimension.  The
% first and second dimensions are controlled by the NOISEVALUES and
% PVALUES parameters:
%
% NOISEVALUES (default 'all'): set of noise values to return
% PVALUES     (default 'all'): set of p values to return
%
% Noise values correspond to rows of RESULTS; p values correspond to
% columns.  Duplicates are allowed in this column (although why you would
% want to...)
%
% RETURNS:
%
% The requested results in RESULTS.  This will be a (n x p x y) array,
% where n is the number of NOISEVALUES, p the number of PVALUES, and y
% the number of results returned (either i or t; see the table above).

% test/get_test_results.m
% Jeremy Barnes, 9/10/1999
% $Id$

% Set up default values for our parameters
if (nargin == 3)
   pvalues = 'all';
elseif (nargin == 2)
   pvalues = 'all';
   noisevalues = 'all';
end

% Make sure our file exists, and get the necessary information from it

info = get_test_info(test);

if (~info.exists)
   error('get_test_results: test doesn''t appear to exist');
end

% Fix up our 'all' values into lists of p or noise
if (isa(pvalues, 'char') & strcmp(pvalues, 'all'))
   pvalues = info.p;
end

if (isa(noisevalues, 'char') & strcmp(noisevalues, 'all'))
   noisevalues = info.noise;
end

% Convert our lists of p/noise values into indexes into the results array
pindex = zeros(size(pvalues));
for i=1:length(pvalues)
   index = find(info.p == pvalues(i));
   if (length(index) ~= 1)
      error('get_test_results: p value not found or duplicate');
   end
   
   pindex(i) = index;
end

noiseindex = zeros(size(noisevalues));
for i=1:length(noisevalues)
   index = find(info.noise == noisevalues(i));
   if (length(index) ~= 1)
      error('get_test_results: noise value not found or duplicate');
   end
   
   noiseindex(i) = index;
end


% Now return the correct results for the test type that we are trying to
% run.  We defer the loading of variables until we are within the switch
% statement in order to conserve memory.

switch type
   case 'train_mean' % mean training error values
      train_mean = load_variable(test, 'train_mean');
      results = train_mean(noiseindex, pindex, :);
      
   case 'train_std' % standard deviation of training values
      train_std = load_variable(test, 'train_std');
      results = train_std(noiseindex, pindex, :);
      
   case 'test_mean' % mean testing error values
      test_mean = load_variable(test, 'test_mean');
      results = test_mean(noiseindex, pindex, :);
      
   case 'test_std' % standard devation of testing error values
      test_std = load_variable(test, 'test_std');
      results = test_std(noiseindex, pindex, :);
      
   case 'counts' % number of trials that made it to each iteration
      count_res = load_variable(test, 'count_res');
      results = count_res(noiseindex, pindex, :);
      
   case 'best_err' % best error value for each trial
      best_test_error = load_variable(test, 'best_test_error');
      results = best_test_error(noiseindex, pindex, :);
      
   case 'best_iter' % training iteration on which best_err occured
      best_test_iter = load_variable(test, 'best_test_iter');
      results = best_test_iter(noiseindex, pindex, :);
      
   otherwise,
      error(['get_test_results: invalid test type ''' type '''.']);
end

% Done.





function var = load_variable(test, varname)

% LOAD_VARIABLE load the variable named 'varname' from the test file
% A simple helper routine to allow us to load only the variables we need
% (thereby saving memory).

global DATA_SAVE_PATH;  % We assume that it exists

% Summary file name
summaryfile = [DATA_SAVE_PATH '/' test '-summary.mat'];

% Try to load in the named variable
load_error = 0;
eval(['load(summaryfile, ''' varname ''');'], 'load_error = 1;');

if (load_error)
   error(['Could not load ' varname ' from ' summaryfile]);
end

% Return our variable
eval(['var = ' varname ';']);

