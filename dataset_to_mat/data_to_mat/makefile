%.lib :	$(MATLAB)/extern/include/%.def
	lib /def:$< /machine:ix86 /out:$@

data2mat.exe: data2mat.c libmat.lib libmx.lib
	cl /W4 /Ic:\MATLAB\extern\include /ML data2mat.c \
		/link libmat.lib libmx.lib