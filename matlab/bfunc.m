% bfunc.m
% Jeremy Barnes, 9/2/1998
% function to calculate the "b" function for boosting

function b = bfunc(terror, phi)
% terror = epsilon_t = training error
% phi = parameter of algorithm = soft margin distance

num = terror .* (1-phi);
den = phi * (ones(size(terror)) - terror);
b = log (num ./ den);
