function h = plot_results(test, type, varargin)

% PLOT_RESULTS general routine to draw graphs of test results
%
% SYNTAX:
%
% plot_results('test', 'type', options..._
%
% This function is a general "graph displaying" function.  It extracts
% data from a summary and draws it into the current graph figure and
% axis (thus, to draw multi-graph sequences you need to use
% display_results, which uses this function to do all of the graph
% plotting).
%
% The TEST parameter tells which test to get the results from.  This test
% must have been created using the MAKETEST function, etc, etc.
%
% The TYPE parameter tells the system which type of graph to draw.
% Possible values are:
%
% 'trainerr'  - just a training error curve
% 'testerr'   - just the test error curve
% 'testtrain' - both test and training curves
%
% 'trainerrdev'  - training error with standard deviation on each side
% 'testerrdev'   - test error with standard deviation on each side
% 'testtraindev' - test and training error with standard deviation
%
% 'traincount'   - plot of number of trials that reached each iteration
%
% 'besterrnoise'* - best test error vs noise (fixed p) (scatter)
% 'besterrp'*     - best test error vs p (fixed noise) (scatter)
% 'bestiternoise'*- best test iteration vs noise (fixed p) (scatter)
% 'bestiterp'*    - best test iteration vs p (fixed noise) (scatter)
%
% (* = requires a noise/p value option; see below)
%
% Each of these types accept a certain number of options.  The options
% are specified in 'name', value pairs.  They are
%
% 'smoothma', period:  Smooth the plots using a <period> iteration moving
%                      average. (not for scatter plots).  Period 0 = off.
%
% 'pvalues', set:      Specifies which p value(s) to draw graphs for when
%                      a fixed p is used. (scatter only)
%
% 'noisevalues', set:  Specifies which noise value(s) to draw graphs for
%                      when a fixed noise value is used. (scatter only)
%
% RETURNS:
%
% H is a list of handles to the plots, one for each plot.

% test/plot_results.m
% Jeremy Barnes, 9/10/1999
% $Id$

