ifdef windir
# This section for MS windows...

DEFAULT_UCI_REPOSITORY = f:/Datasets/

sonar.mat:	sonar.data.txt ../data_to_mat/data2mat.exe
		../data_to_mat/data2mat.exe sonar.data.txt sonar.mat

else
# This section for U*ix...

DEFAULT_UCI_REPOSITORY = ~/engn4000/Datasets/

sonar.mat:	sonar.data.txt ../data_to_mat/data2mat
		../data_to_mat/data2mat sonar.data.txt sonar.mat
endif

ifndef UCI_REPOSITORY
UCI_REPOSITORY = $(DEFAULT_UCI_REPOSITORY)
endif

sonar.data.txt:	./sonar.pl
		./sonar.pl $(UCI_REPOSITORY) > sonar.data.txt

../data_to_mat/data2mat.exe: ../data_to_mat/data2mat.c
		$(MAKE) -C ../data_to_mat  
