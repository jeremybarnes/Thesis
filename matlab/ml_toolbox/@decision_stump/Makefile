# Makefile for MATLAB repository
#
# Causes the mex script to be run on all appropriate files
#
# Expects "mex" to be on the current path
#
# ml_toolbox/@decision_stump/Makefile
# Jeremy Barnes, 20/8/1999
# $Id$

MEXFILES = $(patsubst %.c,%$(MEX_EXTN),$(wildcard *.c))
MEX=mex

all: $(MEXFILES)

%$(MEX_EXTN): %.c
	$(MEX) $(MEXFLAGS) $<



