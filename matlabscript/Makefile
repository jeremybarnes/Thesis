%.lib :	$(MATLAB)/extern/include/%.def
	lib /def:$< /machine:ix86 /out:$@

matlabscript.exe: matlabscript.c libmat.lib libmx.lib libeng.lib getopt.obj
	cl /W4 /Ic:\MATLAB\extern\include /ML matlabscript.c \
		/link libmat.lib libmx.lib libeng.lib getopt.obj

getopt.obj: getopt.c getopt.h
	cl /W4 getopt.c /Fogetopt.obj /c

.DUMMY:	clean

clean:
	-rm *.obj
	-rm *.o
	-rm *.exp
	-rm *.lib
	-rm *.exe
	-rm matlabscript