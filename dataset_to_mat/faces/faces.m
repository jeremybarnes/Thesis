function faces

% FACES convert the faces dataset to a series of mat files

global RAW_DATASET_PATH

if (isempty(RAW_DATASET_PATH))
   error(['faces: you must point global RAW_DATASET_PATH to your' ...
	  ' datasets']);
end

dataset_path = [RAW_DATASET_PATH '/faces'];

% We list all the examples that we have here
usernames = {'an2i', 'bpm', 'choon', 'karyadi', 'megak', 'phoebe', 'sz24', ...
	     'at33', 'ch4f', 'danieln', 'kawamura', 'mitchell', 'saavik', ...
	     'tammo', 'boland', 'cheyer', 'glickman', 'kk49', 'night', ...
	     'steffi'};

directions = {'right', 'left', 'straight', 'up'};

expressions = {'angry', 'happy', 'sad', 'neutral'};

eyes = {'open', 'sunglasses'};


% We create 12 different datasets: 'name', 'direction', 'expression' and
% 'eyes'
datasets = {'name', 'direction', 'expression', 'eyes'};
sizes = {'full', 'half', 'quarter'};
suffixes = {'', '_2', '_4'};

dimensions = 32*30;

xvalues = zeros(0, dimensions);
yvalues = zeros(0, 4);

for name_num=1:length(usernames)
   for dir_num=1:length(directions)
      for expression_num=1:length(expressions)
	 for eyes_num=1:length(eyes)

	    username = usernames{name_num};
	    direction = directions{dir_num};
	    expression = expressions{expression_num};
	    eye = eyes{eyes_num};
	    
	    filename = [dataset_path '/' username '/' username '_' ...
			direction '_' expression '_' eye '_4.pgm'];

	    disp(filename);
	    
	    exec_error = 0;
	    exec('img = load_pgm(filename);', 'exec_error = 1');
	    if (~exec_error)
	       xvalues = [xvalues; img(:)];
	       yvalues = [yvalues; name_num-1 dir_num-1 expression_num-1 ...
			  eyes_num-1];
	    else
	       disp('ERROR: skipped');
	    end
	 end
      end
   end
end

x = xvalues;
y = yvalues(:, 1);
numcategories = length(usernames);
save('faces-name', 'x', 'y', 'dimensions', 'numcategories');

y = yvalues(:, 2);
numcategories = length(expressionss);
save('faces-expression', 'x', 'y', 'dimensions', 'numcategories');

y = yvalues(:, 3);
numcategories = length(eyes);
save('faces-sunglasses', 'x', 'y', 'dimensions', 'numcategories');

y = yvalues(:, 4);
numcategories = length(usernames);
save('faces-name', 'x', 'y', 'dimensions', 'numcategories');
