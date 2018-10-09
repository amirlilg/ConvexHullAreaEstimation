x = 5:5:5000;
S = double(1000);

for i = 5:5:5000
   X = rand([1,i]);
   Y = rand([1,i]);
   XC = X(convhull(X,Y));
   YC = Y(convhull(X,Y));
   
   [XC, YC] = poly2cw(XC,YC);
   S(i/5) = polyarea(XC,YC);
   
   
end

x = log10(x);
figure
xlabel('S');
ylabel('P(S)');
plot(x,S);