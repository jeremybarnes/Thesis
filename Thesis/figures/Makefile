# figures/Makefile
# Jeremy Barnes, 1999
# $Id$

# We have .eps and .epsg files.  EPSG files mean "EPS that can be generated",
# and thus these files are cleaned.  Plain EPS files cannot be generated, and
# thus are not cleaned.

MATLABSCRIPT 	= matlabscript.exe

working_dir 	= $(shell pwd)

.PHONY: 	all
.PHONY:		clean

%.epsg:		%.eps
		mv $< $@

# We need to make an "mscript" since the DOS command line is too short to
# put all of our commands onto
%.mscript:	
		echo "cd $(working_dir)" >> $@
		echo "global EPSFILENAME" >> $@
		echo $(basename $@) >> $@

%.eps: 		%.mscript %.m
		$(MATLABSCRIPT) \
		--run-command "EPSFILENAME = '$@'" \
		--run-file "$<"

# Default target
all:		b_func.epsg regression_problem.epsg \
		classification_problem.epsg dichotomy.epsg \
		margin_illustration.epsg descent.epsg \
		stumpdiagram.epsg stumpcandidates.epsg \
		stumpvcdim.epsg shattering.epsg \
		fat_shattering.epsg vcdim_problems.epsg \
		overfitting.epsg srm.epsg covering.epsg \
		p_convex.epsg sample_weights.epsg \
		classifier_weights.epsg cost_approx.epsg \
		naive.epsg strict_search.epsg sloppy_search.epsg \
		optimal_p_value.epsg boost_overfitting.epsg

clean:		
		-rm *.epsg *.mscript *~