
X = double(100);
Y = double(100);



fileID = fopen('Observation.txt','r');
all = fscanf(fileID,'%f');
%fprintf('a:%f\n',all);
%fprintf('sum of a: %f \n',sum(all));
size_of_all = size(all);
for i = 1:size_of_all(1)/2
    X(i) = all(2*i - 1);
    Y(i) = all(2*i);
end
%getting zarayeb of polynomial
size_of_X = size(X);
q = 1;
zarayeb = polyfit(X,Y,size_of_X(2)-q);
X_fit = linspace(min(X), max(X));
Y_fit = polyval(zarayeb, X_fit);
key =0;

while(1)
    temp = zarayeb;
    zarayeb = polyfit(X,Y,size_of_X(2)-(q+1));
    for j = 1:size_of_X(2)
        if(polyval(zarayeb,X(j)) ~= Y(j))
            %fprintf('we here?\n');
            zarayeb = temp;
            key =1;
            break;
        end
    end
    if(key == 1)
        break;
    end
    if(q == 2)
        fprintf('we here1\n');
        break;
    end
end


plot(X,Y,'Ob');
hold on;
plot(X_fit,Y_fit);
hold off;
fclose(fileID);