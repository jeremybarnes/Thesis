function [img, max_intensity] = load_pgm(filename)

% LOAD_PGM read a .pgm file into a MATLAB array
%
% SYNTAX:
%
% img = load_pgm('filename')
%
% This function reads a .pbm file into the specified filename.  This file
% format is an extremely simple "lowest common denominator" file format.
% There are two variants (P2 -- ascii and p5 -- binary), both of which
% this function can handle.
%
% [img, maxintensity] = load_pgm(...)
%
% This form also returns the maximum intensity field reported by the
% file.

% visualisation/load_pgm.m
% Jeremy Barnes, 3/10/1999
% $Id$

fid = fopen(filename, 'r');
if (fid == -1)
   error('load_pgm: file not found');
end

% Read the first two bytes to find out what type it is
firsttwo = fread(fid, 2, 'uint8')';

if (firsttwo == 'P2')
   ascii = 1;
elseif (firsttwo == 'P5')
   ascii = 0;
else
   error(['load_pbm: unknown PBM file format ' firsttwo]);
end

% Read in the header: [whitespace] width [whitespace] height [whitespace] i
% where i is the maximum image intensity.

res = fscanf(fid, '%d %d %d', 3);

width = res(1);
height = res(2);
max_intensity = res(3);

if (ascii == 1)
   img = fscanf(fid, ' %d', [width, height])';
else
   % Skip over whitespace byte
   junk = fread(fid, 1, 'uint8');
   img = fread(fid, [width, height], 'uint8')';
end

fclose(fid);
