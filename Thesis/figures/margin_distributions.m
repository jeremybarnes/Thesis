function margin_distributions

% margin_distributions.m
% Jeremy Barnes, 20/10/1999
% $Id$

% We draw margin distribution plots for the strict and sloppy algorithms
% Note that we need the individual .mat files to be accessible here

global DATA_SAVE_PATH

pvalues = [1 6 11];
noisevalue = 4;

boost_trial = 10;
normboost_trial = 10;
normboost2_trial = 10;



figure(1);  clf;  setup_figure;

subplot(1, 2, 1);  setup_axis;

title('(a) \sl{Strict cum. margins}');

test = 'normboost-50samples-margins';
trial = normboost_trial;

for i=1:length(pvalues)
   pvalue = pvalues(i);
   
   filename = [DATA_SAVE_PATH '/' test '/' test '-trial' int2str(trial)...
	       '-pvalue' int2str(pvaule) '-noisevalue' ...
	       int2str(noisevalue) '.mat'];
   
   load(filename, 'end_margins');
   

   
end





