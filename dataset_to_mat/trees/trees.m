function trees

% TREES generate trees dataset

% trees.m
% Jeremy Barnes, 14/10/1999
% $Id$

global RAW_DATASET_PATH

if (isempty(RAW_DATASET_PATH))
   error('Must set RAW_DATASET_PATH first');
end

global DATASET_PATH

if (isempty(DATASET_PATH))
   error('Must set DATASET_PATH first');
end

% Run the file to get in the data

olddir = pwd;

eval(['cd ' RAW_DATASET_PATH]);
cd('trees')
mydata;
cd(olddir);

% mydata creates a variable called "karen".  The columns are as
% follows:

%1	easting
%2	northing
%3	site number
%4	elevation 
%5	drainage area
%6	slope (percent)
%7	flow path length
%8	landsat band 1 
%9	band 2
%10	band 3
%11	band 4 
%12	band 5
%13	band 6 
%14	band 7 
%15	nutrient supply index
%16	geology
%17	net radiation
%18	Acacia mabellae
%19	Breynia oblongifolia
%20	Eucalyptus maculata
%21	Eucalyptus tereticornis

% ?????????? what the hell... there are only 20 columns in the
% input file... and they don't seem to correspond (slope 15000%?!)
% Oh well, we will just use all columns.

% We kill column 3, and make four datasets (acacia, breynia,
% maculata, tereticornis).

size(karen)

x = karen(:, 1:16);
ally = karen(:, 17:20);


% acacia
numcategories = 2;
dimensions = 16;
y = ally(:, 1);
save([DATASET_PATH '/acacia.mat'], 'numcategories', 'dimensions', ...
     'x', 'y');


% breynia
numcategories = 2;
dimensions = 16;
y = ally(:, 2);
save([DATASET_PATH '/breynia.mat'], 'numcategories', 'dimensions', ...
     'x', 'y');


% maculata
numcategories = 2;
dimensions = 16;
y = ally(:, 3);
save([DATASET_PATH '/maculata.mat'], 'numcategories', 'dimensions', ...
     'x', 'y');


% tereticornis
numcategories = 2;
dimensions = 16;
y = ally(:, 4);
save([DATASET_PATH '/tereticornis.mat'], 'numcategories', 'dimensions', ...
     'x', 'y');


