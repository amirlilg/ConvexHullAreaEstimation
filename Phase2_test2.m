
X = double(100);
Y = double(100);

prompt = 'ENTER name of file:';
n = input(prompt,'s');



fileID = fopen(n,'r');
all = fscanf(fileID,'%f');

%fprintf('a:%f\n',all);
%fprintf('sum of a: %f \n',sum(all));
size_of_all = length(all);
for i = 1:size_of_all/2
    X(i) = all(2*i - 1);
    Y(i) = all(2*i);
end



q = 1;

prompt = 'ENTER M (size of polynomial)\n[if M = -1, then automatically will be set to size_of_data - 1]:';
m = input(prompt);
while(m~=-1 &&(m < 0 || m > (size_of_all/2)-1))
    fprintf('wrong input! m = -1 OR 0 <= m < size_of_data:');
    m = input(prompt);
end
if(m==-1)
    m = size_of_all/2;
end

zarayeb = polyfit(X,Y,m);



X_fit = linspace(min(X), max(X));
Y_fit = polyval(zarayeb, X_fit);
key =0;



plot(X,Y,'Ob');
hold on;
plot(X_fit,Y_fit);
hold off;
fclose(fileID);