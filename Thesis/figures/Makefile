
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
%.mscript:	Makefile
		echo "cd $(working_dir)" >> $@
		echo "global EPSFILENAME" >> $@
		echo $(basename $@) >> $@

%.eps: 		%.mscript
		$(MATLABSCRIPT) \
		--run-command "EPSFILENAME = '$@'" \
		--run-file "$<"

all:		bfunc.epsg regression_problem.epsg \
		classification_problem.epsg dichotomy.epsg \
		margin_illustration.epsg descent.epsg

clean:		
		-rm *.epsg *.mscript *~