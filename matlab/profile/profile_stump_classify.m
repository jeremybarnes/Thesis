function newc = profile_stump_classify(datatype, numpoints)

% PROFILE_STUMP_CLASSIFIER test the speed of the classify routine

% profile_stump_classify.m
% Jeremy Barnes, 17/5/1999
% $Id$

binary = category_list('binary');
d = dataset(binary, 2);

train_data = datagen(d, datatype, numpoints, 0, 0);
test_data  = datagen(d, datatype, numpoints, 0, 0);

c = decision_stump(binary, 2);
newc = train(c, train_data);
x = x_values(train_data);

numiter = 100;

disp('Coded in MATLAB');

t1 = cputime;

for i=1:numiter
   y = oldclassify(newc, x);
end

t2 = cputime;

elapsed_time = (t2 - t1) / numiter







numiter = 100;

disp('Coded in C');

t1 = cputime;

for i=1:numiter
   y = classify(newc, x);
end

t2 = cputime;

elapsed_time = (t2 - t1) / numiter






%figure(1);
%clf;

%dataplot(train_data);
%plottree(newc, [1 1; 0 0]);

%x = x_values(test_data);
%y = classify(newc, x);

%categorised = addsamples(d, x, y);
%hold on;
%dataplot(categorised, 'g+', 'k*');

%train_error = training_error(newc)
%class_error = classification_error(newc, test_data)

