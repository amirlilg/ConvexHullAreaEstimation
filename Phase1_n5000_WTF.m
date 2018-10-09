x = 5:5:500;
S = double(100);
X = double(power(500,3));
Y = double(power(500,3));



for i = 5:5:500
   jk = power(i,3) - power(i-5,3);
   size_X = size(X);
   for a = 1:1:jk
        R(a) = rand();
        tetta(a) = 2 * pi * rand();
        X(size_X + a - 1) = R(a) * cos(tetta(a));
        Y(size_X + a - 1) = R(a) * sin(tetta(a));
   end
   
   k = convhull(X,Y);
   X = X(k);
   Y = Y(k);
   
   [X, Y] = poly2cw(X,Y);
   S(i/5) = polyarea(X,Y);
   fprintf('S(%d)[%d]:%f\n', i, length(X), S(i/5));
   
end

x = log10(x);
figure
xlabel('S');
ylabel('P(S)');
plot(x,S);