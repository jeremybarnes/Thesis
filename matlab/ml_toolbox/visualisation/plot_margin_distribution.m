function hh = plot_margin_distribution(margins, varargin)

% PLOT_MARGIN_DISTRIBUTION plot cumulative margin distribution
%
% SYNTAX:
%
% plot_margin_distribution(margins, ...)
%
% This function plots a cumulative distribution of the margins passed as
% a parameter.  There may be any number of margins, and these may range
% over any values.
%
% The x axis always goes from -|m| to +|m| where |m| is the maximum
% margin value.  If, however, |m|<=1, then the graph goes from -1 to +1.
%
% plot_margin_distribution(margins, 'option', value, ...)
%
% This form also allows optional parameters to be passed.  These
% parameters are:
%
% 'linestyle', 'k-'     Plots the graph in the specified style
% 'xrange', [-n m]      Forces the axis to range over the specified
%                       values
% 'normalise', 1        Boolean; normalise weights to range from -1 to +1
%
% h = plot_margin_distribution(...)
%
% This form returns the handle of the line object created.

% visualisation/plot_margin_distribution.m
% Jeremy Barnes, 19/10/1999
% $Id$

% Default options
opt.linestyle = 'b-';
opt.normalise = 0;

% Sort out our options
for i=1:length(varargin)./2
   name = varargin{i*2-1};
   value = varargin{i*2};
   
   switch name
      case 'linestyle'
	 opt.linestyle = value;
      case 'xrange'
	 opt.xrange = value;
      case 'normalise'
	 opt.normalise = value;
      otherwise,
	 error(['Invalid option name ''' name '''']);
   end
end

if (opt.normalise)
   margins = margins./max(abs(margins));
end

n = min(margins);
m = max(margins);

xrange = max(abs(n), abs(m));
if (xrange <= 1)
   xrange = 1;
end

xvalues = linspace(-xrange, xrange, 101);
yvalues = zeros(size(xvalues));

% Work out the distribution.  This current function is terribly
% inefficient, but it shouldn't matter too much for reasonably sized
% datasets...

for i=1:length(xvalues)
   yvalues(i) = sum(margins < xvalues(i));
end

% Plot me baby...

h = plot(xvalues, yvalues./length(margins).*100, opt.linestyle);

% Return a value if they want it
if (nargout == 1)
   hh = h;
end
   
