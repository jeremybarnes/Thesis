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

.PHONY : all

all:	Makefile
	$(foreach dir, $(SUBDIRS), make -C $(dir) ;)
	touch .done~


