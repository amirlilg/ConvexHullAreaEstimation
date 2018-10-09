
X = double(100);
Y = double(100);

prompt = 'ENTER name of file:';
n = input(prompt,'s');

fileID = fopen(n,'r');
all = fscanf(fileID,'%f');

size_of_all = length(all);
start_X = all(1);
end_X = all(2);
for i = 1:((size_of_all/2)-1)
    X(i) = all(2*i + 1);
    Y(i) = all(2*i + 2);
end

size_of_observation = length(X);
moments = double(size_of_observation);
moments(1) = mean(X);
for i = 2:size_of_observation
    moments(i) = mean( power(X-mean(X) , i) );
end
















