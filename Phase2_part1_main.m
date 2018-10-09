
X = double(100);
Y = double(100);

prompt = 'ENTER name of file:';
n = input(prompt,'s');



fileID = fopen(n,'r');
all = fscanf(fileID,'%f');

%fprintf('a:%f\n',all);
%fprintf('sum of a: %f \n',sum(all));
size_of_all = length(all);
start_X = all(1);
end_X = all(2);
for i = 1:((size_of_all/2)-1)
    X(i) = all(2*i + 1);
    Y(i) = all(2*i + 2);
end

size_of_observation = length(X);

q = 1;

prompt = 'ENTER M (size of polynomial)\n[if M = -1, then automatically will be set to (size_of_data - 1)]:';
m = input(prompt);
while(m~=-1 &&(m < 0 || m > size_of_observation))
    fprintf('wrong input! m = -1 OR 0 <= m < size_of_data:');
    m = input(prompt);
end
if(m==-1)
    m = size_of_all/2;
end

zarayeb = polyfit(X,Y,m-1);

a1 = max(start_X,min(X)) - ( min(end_X, max(X)) - max(start_X,min(X)) )/6;
a2 = min(end_X, max(X)) + ( min(end_X, max(X)) - max(start_X,min(X)) )/6;

X_fit = linspace(a1 , a2);
Y_fit = polyval(zarayeb, X_fit);
key = 0;


a3 = min(Y_fit) - ( max(Y_fit) - min(Y_fit) )/6;
a4 = max(Y_fit) + ( max(Y_fit) - min(Y_fit) )/6;


plot(X,Y,'Ob');
axis([a1 a2 a3 a4]);
hold on;
plot(X_fit,Y_fit);
hold off;
fclose(fileID);
