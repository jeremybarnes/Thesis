sonar.mat:	sonar.data.txt ../data_to_mat/data2mat.exe
		../data_to_mat/data2mat.exe sonar.data.txt sonar.mat

sonar.data.txt:	./sonar.pl
		perl ./sonar.pl > sonar.data.txt

../data_to_mat/data2mat.exe: ../data_to_mat/data2mat.c
		$(MAKE) -C ../data_to_mat  
