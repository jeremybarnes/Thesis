function current_test()

% CURRENT_TEST run the current test
%
% SYNTAX:
%
% current_test
%
% Runs whatever command I decide is the current one.  Eventually I
% hope for this to look at what .mat files have been written and
% from those decide which is the current one automatically.
%
% Currently, it is just a way to save myself typing.

% test/current_test.m
% Jeremy Barnes, 1/7/1999
% $Id$

global data_save_path;

data_save_path = '/home/jeremy/engn4000/data';

complete_pboost_test('ring', 2, 100, 0.1, 5000, 5, 200, 0.8, ...
		     'decision_stump');


