function h = display_results(test, type, varargin)

% DISPLAY_RESULTS display collated test results
%
% SYNTAX:
%
% display_results('test', 'type', options..._
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
% 'traincount'   - plot of number of trials that reached each iteration
% 'bestmargins'  - plot of margins at the best test result
% 'endmargins'   - plot of margins at the last test result
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
% 'comparewith', test: Uses the performance values in 'test' as a
%                      baseline for comparison.  Should be boost as it
%                      doesn't depend upon p.
%
% RETURNS:
%
% H is a list of handles to the plots, one for each plot.

% display_results.m
% Jeremy Barnes, 23/9/1999
% $Id$

% Default option
opt.plot_cols = 4;
opt.plot_rows = 4;
opt.x_range = 'tight';
opt.y_range = 'tight';
opt.equal_y = 1;
opt.equal_x = 1;
opt.axis_function = 'default_setup_axis';
opt.figure_function = 'default_setup_figure';
opt.test_err_style = 'r-';
opt.train_err_style = 'b-';
opt.title_format = 'default';
opt.pvalues = 'all';
opt.noisevalues = 'all';
opt.gridtype = 'on';
opt.xlabelvalue = 'default';
opt.ylabelvalue = 'default';
opt.clabelvalue = 'default';
opt.comparewith = [];
opt.stdev_curves = 1;
opt.errorbars = 0;
opt.display_counts = 0;
opt.showminimum = 0;
opt.squareaxis = 0;

% Parse our options
for i=1:length(varargin)./2
   opt_name = varargin{i*2-1};
   opt_value = varargin{i*2};
   
   switch opt_name
      case 'cols'
	 opt.plot_cols = opt_value;
      case 'rows'
	 opt.plot_rows = opt_value;
      case 'x_range'
	 opt.x_range = opt_value;
      case 'y_range'
	 opt.y_range = opt_value;
      case 'equal_x'
	 opt.equal_x = read_boolean(opt_value);
      case 'equal_y'
	 opt.equal_y = read_boolean(opt_value);
      case 'axis_function'
	 opt.axis_function = opt_value;
      case 'figure_function'
	 opt.figure_function = opt_value;
      case 'test_err_style'
	 opt.test_err_style = opt_value;
      case 'train_err_style'
	 opt.train_err_style = opt_value;
      case 'title'
	 opt.title_format = opt_value;
      case 'pvalues'
	 opt.pvalues = opt_value;
      case 'noisevalues'
	 opt.noisevalues = opt_value;
      case 'grid'
	 opt.gridtype = opt_value;
      case 'xlabel'
	 opt.xlabelvalue = opt_value;
      case 'ylabel'
	 opt.ylabelvalue = opt_value;
      case 'comparewith'
	 opt.comparewith = opt_value;
      case 'stdev'
	 opt.stdev_curves = opt_value;
      case 'errorbars'
	 opt.errorbars = opt_value;
      case 'display_counts'
	 opt.display_counts = opt_value;
      case 'show_minimum'
	 opt.showminimum = opt_value;
      case 'squareaxis'
	 opt.squareaxis = opt_value;
      otherwise,
	 error(['Unknown option ''' opt_name '''.']);
   end
end

% default status values
status.current_fig = 0;
status.current_subplot = 1000000;
status.axis_h = [];

% Generic stuff goes here

% Find out about the test that we are plotting
test_info = get_test_info(test);
      


switch type
   
   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   case {'testerr', 'trainerr', 'testtrain'}

      % Get the actual values we are looking at
      if (strcmp(opt.noisevalues, 'all'))
	 noisevalues = test_info.noise;
      else
	 noisevalues = intersect(test_info.noise, opt.noisevalues);
      end
      
      if (strcmp(opt.pvalues, 'all'))
	 pvalues = test_info.p;
      else
	 pvalues = intersect(test_info.p, opt.pvalues);
      end
      
      % Go through and load all of our files
      train_mean = get_test_results(test, 'train_mean', noisevalues, pvalues);
      train_std  = get_test_results(test, 'train_std',  noisevalues, pvalues);
      
      test_mean = get_test_results(test, 'test_mean', noisevalues, pvalues);
      test_std  = get_test_results(test, 'test_std',  noisevalues, pvalues);

      counts = get_test_results(test, 'counts', noisevalues, pvalues);
      
      % Sort out the title
      if (strcmp(opt.title_format, 'default'))
	 ln = length(test_info.noise);
	 lp = length(test_info.p);
	 
	 if ((ln == 1) & (lp == 1))
	    opt.title_format = 'Test/training error';
	 elseif ((ln == 1) & (lp > 1))
	    opt.title_format = 'p = %p';
	 elseif ((ln > 1) & (lp == 1))
	    opt.title_format = 'noise = %n';
	 else
	    opt.title_format = 'noise = %n  p = %p';
	 end
      end

      % Sort out the label values
      if (strcmp(opt.xlabelvalue, 'default'))
	 opt.xlabelvalue = 'Iterations';
      end
      
      if (strcmp(opt.ylabelvalue, 'default'))
	 opt.ylabelvalue = 'Error';
      end

      if (strcmp(opt.clabelvalue, 'default'))
	 opt.clabelvalue = 'Trials';
      end
      
      for noisevalue=1:length(noisevalues)
	 current_noise = noisevalues(noisevalue);
	 for pvalue=1:length(pvalues)
	    current_p = pvalues(pvalue);
	    
	    status = next_plot(opt, status);
	    
	    train_d = permute(train_mean(noisevalue, pvalue, :), [3 1 2]);
	    test_d  = permute(test_mean (noisevalue, pvalue, :), [3 1 2]);
	    count_d = permute(counts    (noisevalue, pvalue, :), [3 1 2]); 

	    min_iter = find(test_d == min(test_d));
	    min_iter = min_iter(1);
	    min_error = test_d(min_iter);
	    
	    graphtitle = parse_title(opt.title_format, current_noise, ...
				     current_p, status.current_subplot);

	    % Get rid of samples that are -1 (training stopped)
	    minus1 = find(test_d < 0);
	    if (~isempty(minus1))
	       stopat = minus1(1) - 1;
	       test_d = test_d(1:stopat);
	       train_d = train_d(1:stopat);
	    end

	    iter = 1:length(test_d);
	    
	    % We need to mangle the hell out of it to get double axes
	    if (opt.display_counts)
	       iter = 1:length(count_d);

	       if (strcmp(type, 'testtrain'))
		  [ax, h1, h2] = plotyy(1:length(test_d), test_d, iter, count_d);
		  hold on;
		  set(ax(2), 'xscale', 'log');
		  set(ax(1), 'xscale', 'log');
		  set(ax(2), 'ylim', [0 test_info.trials]);
		  delete(h1);
		  semilogx(1:length(test_d), test_d, opt.test_err_style);
		  semilogx(1:length(train_d), train_d), opt.train_err_style;
	       elseif (~isempty(findstr(type, 'test')))
		  [ax, h1, h2] = plotyy(iter, test_d, iter, count_d);
		  hold on;
	       elseif (~isempty(findstr(type, 'train')))
		  [ax, h1, h2] = plotyy(iter, train_d, iter, count_d);
		  hold on;
	       end
	       
	       set(ax(2), 'ylim', [0 test_info.trials*1.1], ...
			  'ytickmode', 'auto');
	       set(h2, 'linestyle', '--', 'color', 'k');
	       set(ax(1), 'ylim', [0 0.5], 'ytickmode', 'auto');
	    
	       xlabel(opt.xlabelvalue);
	       ylabel(opt.ylabelvalue);
	       
	       if (~isempty(graphtitle))
		  title(graphtitle);
	       end
	    
	    else
               if (~isempty(findstr(type, 'test')))
		  iter = 1:length(train_d);
		  semilogx(iter, test_d, opt.test_err_style);  hold on;
	       end
	       
	       if (~isempty(findstr(type, 'train')))
		  iter = 1:length(train_d);
		  semilogx(iter, train_d, opt.train_err_style);
	       end
	    
	       xlabel(opt.xlabelvalue);
	       ylabel(opt.ylabelvalue);
	    
	       if (~isempty(graphtitle))
		  title(graphtitle);
	       end
	    end
	    
	    % Fix up x axis
	    if (strcmp(opt.x_range, 'tight'))
	       ax = axis;
	       ax(1) = 1;
	       ax(2) = test_info.numiterations;
	       axis(ax);
	    else
	       ax = axis;
	       ax(1) = x_range(1);
	       ax(2) = x_range(2);
	       axis(ax);
	    end
	    
	    if (size(opt.y_range) == [1 2])
	       ax = axis;
	       ax(3) = opt.y_range(1);
	       ax(4) = opt.y_range(2);
	       axis(ax);
	    end
	    
	    if (opt.showminimum)
	       plot(min_iter, min_error, 'ko', 'markersize', 10);
	       plot([1 min_iter], [min_error, min_error], 'k-.');
	       plot([min_iter min_iter], [0 min_error], 'k-.');
	    end

	    if (opt.squareaxis)
	       axis square;
	    end
	    
	    grid(opt.gridtype);
	 end
      end

      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   case {'besterrp', 'bestiterp'}
      % We are plotting the best error or best iteration against p.
      
      if (~isempty(opt.comparewith))
	 % Load in the summary-summary for the test that we are comparing with
	 filename = [DATA_SAVE_PATH '/' opt.comparewith '/' ...
		     opt.comparewith '-sum-sum.mat'];
	 load(filename, 'test_info', 'avg_err', 'std_err', 'avg_iter', ...
	      'std_iter');
	 cmp_info = test_info;
	 cmp_avg_err = avg_err;
	 cmp_std_err = std_err;
	 cmp_avg_iter = avg_iter;
	 cmp_std_iter = std_iter;
	 cmp_noise = test_info.noise;
      end
      
      best_err = get_test_results(test, 'best_err');
      best_iter = get_test_results(test, 'best_iter');

      % row = noise, col = p, d3 = errors

      % Make into one big matrix
      pvalues = zeros(1, length(test_info.p) .* test_info.trials);

      err_results = zeros(length(test_info.noise), ...
			  length(test_info.p) .* test_info.trials);
      iter_results = zeros(length(test_info.noise), ...
			   length(test_info.p) .* test_info.trials);

      err_means = zeros(length(test_info.noise), length(test_info.p));
      err_stdevs = zeros(length(test_info.noise), length(test_info.p));

      iter_means = zeros(length(test_info.noise), length(test_info.p));
      iter_stdevs = zeros(length(test_info.noise), length(test_info.p));

      % Calculate statistics
      for i=1:length(test_info.noise)
	 
	 this_part_err = best_err(i, :, :);
	 this_part_iter = best_iter(i, :, :);
	 
	 these_p_results = [];
	 these_err_results = [];
	 these_iter_results = [];
	 
	 for j=1:length(test_info.p)
	    
	    err_means(i, j) = mean(this_part_err(1, j, :), 3);
	    err_stdevs(i, j) = std(this_part_err(1, j, :), 3);
	    
	    iter_means(i, j) = mean(this_part_iter(1, j, :), 3);
	    iter_stdevs(i, j) = std(this_part_iter(1, j, :), 3);
	    
	    these_p_results = [these_p_results ...
			       ones(1, test_info.trials) .* test_info.p(j)];
	    these_err_results = [these_err_results ...
		    permute(this_part_err(1, j, :), [1 3 2])];
	    these_iter_results = [these_iter_results ...
		    permute(this_part_iter(1, j, :), [1 3 2])];
	 end
	 
	 err_results(i, :) = these_err_results;
	 iter_results(i, :) = these_iter_results;
	 pvalues = these_p_results;
      end


      % Draw graphs
      status = next_plot(opt, status);

      if (strcmp(type, 'besterrp'))
	 % Graphs of p vs best error
	 for i=1:length(test_info.noise)
	    if (length(test_info.noise == 1))
	       subplot(2, 1, i*2-1);
	    else
	       subplot(length(test_info.noise), 2, i*2-1);
	    end
	    
	    plot(pvalues, err_results(i, :), 'rx');  hold on;
	    plot(test_info.p, err_means(i, :), 'b-');

	    % Plot standard deviation bars if required
	    if (opt.stdev)
	       plot(test_info.p, err_means(i, :) + err_stdevs(i, :), 'b:');
	       plot(test_info.p, max(err_means(i, :) - err_stdevs(i, :), ...
				     0), 'b:');
	    end
	    
	    % Plot baseline if required
	    if (opt_comparewith)
	       % Plot a baseline and limits for the comparewith
	       
	       % First, find which noise value to use
	       n = test_info.noise(i);
	       index = find(cmp_noise == n);
	       if (~isempty(index))
		  this_avg_err = cmp_avg_err(index);
		  this_std_err = cmp_std_err(index);
		  m = this_avg_err;
		  u = this_avg_err + this_std_err;
		  l = this_avg_err - this_std_err;
		  plot([min(test_info.p) max(test_info.p)], [m m], 'k-', ...
		       'linewidth', 2);
		  plot([min(test_info.p) max(test_info.p)], [u u], 'k:', ...
		       'linewidth', 2);
		  if (l > 0)
		     plot([min(test_info.p) max(test_info.p)], [l l], 'k:', ...
			  'linewidth', 2);
		  end
	       end
	    end
	    
	    %   title(['Noise = ' num2str(test_info.noise(i))]);
	    %   xlabel('p');
	    %   ylabel('Best test error');
	    grid on;
	 end

      else
	 % Graphs of p vs best iteration
	 for i=1:length(test_info.noise)
	    if (length(test_info.noise == 1))
	       subplot(2, 1, i*2);
	    else
	       subplot(length(test_info.noise), 2, i*2);
	    end
	    
	    semilogy(pvalues, iter_results(i, :), 'rx');  hold on;
	    plot(test_info.p, iter_means(i, :), 'b-');
	    
	    % Plot standard deviation if required
	    if (opt.stdev)
	       plot(test_info.p, iter_means(i, :) + iter_stdevs(i, :), 'b:');
	       plot(test_info.p, max(iter_means(i, :) - iter_stdevs(i, :), ...
				     0), 'b:');
	    end
	    
	    % Compare with other graph if required
	    if (opt_comparewith)
	       % Plot a baseline and limits for the comparewith
	       
	       % First, find which noise value to use
	       n = test_info.noise(i);
	       index = find(cmp_noise == n);
	       if (~isempty(index))
		  this_avg_iter = cmp_avg_iter(index);
		  this_std_iter = cmp_std_iter(index);
		  m = this_avg_iter;
		  u = this_avg_iter + this_std_iter;
		  l = this_avg_iter - this_std_iter;
		  plot([min(test_info.p) max(test_info.p)], [m m], 'k-', ...
		       'linewidth', 2);
		  plot([min(test_info.p) max(test_info.p)], [u u], 'k:', ...
		       'linewidth', 2);
		  if (l > 0)
		     plot([min(test_info.p) max(test_info.p)], [l l], 'k:', ...
			  'linewidth', 2);
		  end
	       end
	    end
	    
	    %   title(['Noise = ' num2str(test_info.noise(i))]);
	    %   xlabel('p');
	    %   ylabel('Best test iteration');
	    grid on;
	 end
      end
end

      
% Return our axes if needed
if (nargout == 1)
   h = status.axis_h;
end


function title = parse_title(format, noise, p, subplot)

% Doesn't handle multiple %s properly.

keywords = {'%%', '%', '%n', num2str(noise), '%p', num2str(p), ...
	    '%l', 96 + subplot, '%N', [num2str(100*noise) '%']};

% Find any keywords that match and replace them with the replacement
% string

title = format;

for i=1:length(keywords)./2
   kw = keywords{i*2-1};
   index = findstr(kw, title);
   while (length(index) > 0)
      index = index(1);
      title(index:index+length(kw)-1) = [];
      before = title(1:index-1);
      after = title(index:length(title));
      title = [before keywords{i*2} after];
      index = findstr(kw, title);
   end
end



function default_setup_figure

% Does nothing by default


function default_setup_axis

% Does nothing by default


function new_status = next_plot(opt, status)

% Move onto the next figure

if (status.current_subplot > opt.plot_rows*opt.plot_cols)
   status.current_subplot = 1;
   status.current_fig = status.current_fig + 1;
   figure(status.current_fig);  clf;
   eval(opt.figure_function);
else
   status.current_subplot = status.current_subplot + 1;
end

subplot(opt.plot_rows, opt.plot_cols, status.current_subplot);
eval(opt.axis_function);
status.axis_h = [status.axis_h; gca];
new_status = status;

