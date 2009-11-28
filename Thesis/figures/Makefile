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
#%.epsg:		%.eps
#		sed -e 's/^ *-*[0-9][0-9]* *-*[0-9][0-9]* *-*[0-9][0-9]* *-*[0-9][0-9]* rc/%&/' $< > tmpfile
#		sed -e 's/^ *-*[0-9][0-9]* *-*[0-9][0-9]* *-*[0-9][0-9]* *-*[0-9][0-9]* rf/%&/' tmpfile > $@
#		rm tmpfile

%.pdf:		%.epsg
		cat $< | epstopdf --filter > $@~
		mv $@~ $@

ifeq ($(OSTYPE),Linux)
# Linux target -- we call MATLAB in a different manner

working_dir 	= $(shell pwd)


#%.eps: 		%.m
#		echo "global EPSFILENAME" > tmpcommand
#		echo "cd $(working_dir)" >> tmpcommand
#		echo "EPSFILENAME = '$@'" >> tmpcommand
#		echo $(basename $@) >> tmpcommand
#		matlab < tmpcommand
#		rm tmpcommand

else
# Windows 95 target -- use MATLABscript

MATLABSCRIPT 	= matlabscript.exe

working_dir 	= $(shell pwd)

# We need to make an "mscript" since the DOS command line is too short to
# put all of our commands onto
#%.mscript:	
#		echo "cd $(working_dir)" >> $@
#		echo "global EPSFILENAME" >> $@
#		echo $(basename $@) >> $@

#%.eps: 		%.mscript %.m
#		$(MATLABSCRIPT) \
#		--run-command "EPSFILENAME = '$@'" \
#		--run-file "$<"

endif

# Default target
all:		b_func.pdf classification_problem.pdf \
		descent.pdf stumpdiagram.pdf stumpcandidates.pdf \
		shattering.pdf vcdim_problems.pdf \
		overfitting.pdf srm.pdf covering.pdf \
		p_convex.pdf sample_weights.pdf \
		classifier_weights.pdf cost_approx.pdf \
		naive.pdf strict_search.pdf sloppy_search.pdf \
		optimal_p_value.pdf boost_overfitting.pdf \
		test_err_summary.pdf test_iter_summary.pdf \
		effect_of_p.pdf \
		adaboost_margins.pdf training_curves_strict.pdf \
		training_curves_sloppy.pdf training_curves_boost.pdf \
		alpha_function.pdf weight_distributions.pdf \
		alpha_function_sum.pdf ring_distribution.pdf

clean:		
		-rm *.mscript *~ tmpcommand tmpfile