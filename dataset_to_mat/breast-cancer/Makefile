.DUMMY : all

all:	wdbc.mat wpbc.mat breast-cancer-wisconsin.mat

ifdef windir
# This section for MS windows...

DEFAULT_UCI_REPOSITORY = f:/Datasets/

%.mat:	%.data.txt ../data_to_mat/data2mat.exe
	../data_to_mat/data2mat.exe $< $@

else
# This section for U*ix...

DEFAULT_UCI_REPOSITORY = ~/engn4000/Datasets/

%.mat:	%.data.txt ../data_to_mat/data2mat
	../data_to_mat/data2mat $< $@
endif

ifndef UCI_REPOSITORY
UCI_REPOSITORY = $(DEFAULT_UCI_REPOSITORY)
endif

%.data.txt:	./%.pl
		$< $(UCI_REPOSITORY) > $@

../data_to_mat/data2mat.exe: ../data_to_mat/data2mat.c
		$(MAKE) -C ../data_to_mat  
