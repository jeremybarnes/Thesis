% REGEX match a regular expression
%
% SYNTAX:
%
% matched = regex('pattern', string);
% [matched, refs] = regex('pattern', string);
% [matched, ref1, ref2, ..., refn] = regex('pattern', string, 'individual');
% [didmatch, ...] = regex('pattern', string, 'binary');
%
% This function is an interface to the GNU regex library (version
% 0.12 at this writing).  See the texinfo documentation for more
% information about how to write and use regular expressions.
%
% The first form simply matches the regular expression and returns
% the part that matched in MATCHED.
%
% The second form returns the matched string in MATCHED, and the
% backreferences in a cell array REFS.
%
% The third form returns the matched string in MATCHED, and sets
% the variables ARG1 through ARGN to the first n matched
% variables.  The 'individual' flag is implicitly set if there are
% more than two (or three, if the 'boolean' flag is set) output
% arguments.  If there are more output arguments than
% backreferences, then the extra ones are set to the null string.
%
% The 'boolean' flag can be set to force an extra boolean (1 or 0)
% output to be generated which can be directly interrogated for a
% match.  Otherwise, the isempty operator can be used to do the
% same thing.
%
% If there is an error in the pattern, then an error is generated
% with the message returned by the regex library.

% regex.m
% Jeremy Barnes, 9/9/1999
% $Id$

% Implemented in a c-file
