# Makefile for MATLAB repository
#
# Causes the mex script to be run on all appropriate files
#
# Expects "mex" to be on the current path
#
# ml_toolbox/Makefile
# Jeremy Barnes, 20/8/1999
# $Id$

SUBDIRS=@boost @cart @decision_stump 
MEXFILES = $(patsubst %.c,%$(MEX_EXTN),$(wildcard *.c))
MEX=mex

.PHONY : all

all:	Makefile $(MEXFILES)
	$(foreach dir, $(SUBDIRS), make -C $(dir) ;)
	touch .done~

%$(MEX_EXTN): %.c
	$(MEX) $(MEXFLAGS) $<

