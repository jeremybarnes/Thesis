function obj_r = load(obj, filename)

% LOAD load a dataset from a MAT file
%
% SYNTAX:
%
% obj_r = load(obj, 'filename')
%
% This function loads the file in FILENAME.  This is expected to be a MAT
% file with X, Y, NUMCATEGORIES and DIMENSIONS fields.
%
% RETURNS:
%
% The loaded dataset in OBJ_R.

% @dataset/load.m
% Jeremy Barnes, 3/10/1999
% $Id$

global DATASET_PATH;

% Put dummy declarations here so that MATLAB doesn't shadow the variables
% with methods it will never call (must do it at compile time).
numcategories = 2;
dimensions = 2;
x = [];
y = [];

load_error = 0;
eval('load(filename, ''x'', ''y'', ''numcategories'', ''dimensions'');' ...
     , 'load_error = 1;');

% Try again if there's an error
if (load_error)
   load_error = 0;
   filename2 = [DATASET_PATH '/' filename];
   eval('load(filename2, ''x'', ''y'', ''numcategories'', ''dimensions'');' ...
	, 'load_error = 1;');
end
   
% No luck... give up
if (load_error)
   error(['load: file "' filename2 '" not found']);
end

% Create our dataset object

obj.dimensions = dimensions;
obj.numcategories = numcategories;
obj.x_values = x;
obj.y_values = y;
obj.numsamples = length(y);

obj_r = obj;




