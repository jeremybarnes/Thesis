# Makefile for MATLAB regular expression support
# Jeremy Barnes, 9/9/1999
# $Id$

# Set this to the path that the GNU regex library is installed in
# Alternatively, specify it on the command line:
# make regex_path=~/source/gnu/regex-0.12
regex_path = /home/jeremy/src/regex-0.12

# Set this path where you want it installed
install_path = /home/jeremy/matlab

# The extension of MEX files on this architecture
MEX_EXTN = .mexlx

# Run 'make DEBUG=1' to make a debugging version
ifeq ($(DEBUG), 1)
debug_flags = -g
mex_debug = -g
else
debug_flags = 
mex_debug = 
endif

# These cause MATLAB's memory management functions to be used instead of GNU's
regex_defines = '-Dmalloc(x)=mxCalloc(1, (x))' \
		'-Drealloc(x, y)=mxRealloc((x),(y))' \
		'-Dfree(x)=mxFree((x))'

INCLUDES = -I$(MATLAB)/extern/include -I$(regex_path)
FLAGS = -Wall -DMATLAB_MEX_FILE $(debug_flags)
export CFLAGS = $(regex_defines) $(debug_flags)

CURRENT_DIR = $(shell pwd)


.DUMMY:		default

default:	regex$(MEX_EXTN)

regex.o:	regex.c
		$(CC) $(FLAGS) $(INCLUDES) -c regex.c


regex$(MEX_EXTN):	regex.o gnu_regex.o
		mex $(mex_debug) regex.o gnu_regex.o

$(regex_path)/regex.o:
		$(MAKE) -C $(regex_path) -e regex.o

gnu_regex.o:	$(regex_path)/regex.o
		mv $(regex_path)/regex.o gnu_regex.o

.DUMMY: 	install

install:	regex$(MEX_EXTN) regex.m
		cp regex$(MEX_EXTN) $(install_path)
		cp regex.m $(install_path)

.DUMMY:		clean

clean:		
		-rm *.o *~ *.mexlx

