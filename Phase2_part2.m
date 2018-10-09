prompt = 'enter landa of exponential(0 < landa < 1.5): ';
landa = input(prompt);
while( landa <= 0 || landa >= 1.5)
    fprintf('wrong input! 0 < landa < 1.5. try again: ')
    landa = input(prompt);
end

prompt = 'enter size of data (2 <= size <= 20): ' ;
size = input(prompt);
while( size < 2 || size > 20)
    fprintf('wrong input! 2 <= size <= 20. try again: ')
    size = input(prompt);
end

delta = 10;
x = delta * rand([1,size]);
px_1 = landa * exp(-landa * x);
plot(x,px_1,'*b');
xlabel('x');
ylabel('p(x)');
zarayeb = polyfit(x,px_1,size-1);
X_fit = linspace(-1, 11);
Y_fit = polyval(zarayeb, X_fit);
hold on;
plot(X_fit,Y_fit,'-b');
%end
%if(n == 2)
x1 = delta * rand([1,size]);
px_2 = 1/delta * power(x1,0);
plot(x1,px_2,'*r');
zarayeb = polyfit(x1,px_2,1);
X_fit = linspace(-1, 11);
Y_fit = polyval(zarayeb, X_fit);
hold on;
plot(X_fit,Y_fit,'-r');
axis([min(min(x1),min(x))-1 max(max(x1),max(x))+1 0 max(max(px_1),max(px_2))+.1]);
xticks(0:1:delta);
yticks(0:0.1:max(1,landa));
hold off;

%end