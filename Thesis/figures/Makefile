# figures/Makefile
# Jeremy Barnes, 1999
# $Id$

# We have .eps and .epsg files.  EPSG files mean "EPS that can be generated",
# and thus these files are cleaned.  Plain EPS files cannot be generated, and
# thus are not cleaned.

.PHONY: 	all
.PHONY:		clean

# Our .epsg rule also fixes the dodgy Matlab EPS to remove the command that
# clips to the bounding box.
%.epsg:		%.eps
		sed -e 's/^ *-*[0-9][0-9]* *-*[0-9][0-9]* *-*[0-9][0-9]* *-*[0-9][0-9]* rc/%&/' $< > $@


ifeq ($(OSTYPE),Linux)
# Linux target -- we call MATLAB in a different manner

working_dir 	= $(shell pwd)


%.eps: 		%.m
		echo "global EPSFILENAME" > tmpcommand
		echo "cd $(working_dir)" >> tmpcommand
		echo "EPSFILENAME = '$@'" >> tmpcommand
		echo $(basename $@) >> tmpcommand
		matlab < tmpcommand
		rm tmpcommand

else
# Windows 95 target -- use MATLABscript

MATLABSCRIPT 	= matlabscript.exe

working_dir 	= $(shell pwd)

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

endif

# Default target
all:		b_func.epsg classification_problem.epsg \
		descent.epsg stumpdiagram.epsg stumpcandidates.epsg \
		shattering.epsg vcdim_problems.epsg \
		overfitting.epsg srm.epsg covering.epsg \
		p_convex.epsg sample_weights.epsg \
		classifier_weights.epsg cost_approx.epsg \
		naive.epsg strict_search.epsg sloppy_search.epsg \
		optimal_p_value.epsg boost_overfitting.epsg \
		test_err_summary.epsg test_iter_summary.epsg \
		effect_of_p.epsg margin_distribution.epsg \
		adaboost_margins.epsg training_curves_strict.epsg \
		training_curves_sloppy.epsg training_curves_boost.epsg \
		alpha_function.epsg

clean:		
		-rm *.epsg *.mscript *~ tmpcommand