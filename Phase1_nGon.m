%phase 1 -  n-gon overlapping area
loopOfExperiments = 300;
numOfIntervals = 50;
intervals = double(loopOfExperiments);
for i= 1:1:numOfIntervals
    intervals(i) = 0;
end
S_intervals = double(numOfIntervals);

S = double(loopOfExperiments);
size_X = double(loopOfExperiments);
n = 0;
prompt = 'ENTER N:';
n = input(prompt);
while(n == 1 || n == 0 || n == 2)
    fprintf('wrong input! try again!\n');
    n = input(prompt);
end


X1 = double(n*n);
Y1 = double(n*n);
X2 = double(n*n);
Y2 = double(n*n);

for i = 1:loopOfExperiments %1 to be replaced with loopOfExperiments
    X1 = rand([1,n]);
    Y1 = rand([1,n]);
    X2 = rand([1,n]);
    Y2 = rand([1,n]);
    size1 = length(convhull(X1,Y1));
    size2 = length(convhull(X2,Y2));
    while(size1 < n+1)
        howMany = n + 1 - size1;
        for k = 1:howMany
            X1(length(X1)+1) = rand([1,1]);
            Y1(length(Y1)+1) = rand([1,1]);
        end
        size1 = length(convhull(X1,Y1));
    end
    while(size2 < n+1)
        howMany = n + 1 - size2;
        for k = 1:howMany
            X2(length(X2)+1) = rand([1,1]);
            Y2(length(Y2)+1) = rand([1,1]);
        end
        size2 = length(convhull(X2,Y2));
    end
    X1_Ngon = X1(convhull(X1,Y1));
    X2_Ngon = X2(convhull(X2,Y2));
    Y1_Ngon = Y1(convhull(X1,Y1));
    Y2_Ngon = Y2(convhull(X2,Y2));
    [X1_Ngon, Y1_Ngon] = poly2cw(X1_Ngon,Y1_Ngon);
    [X2_Ngon, Y2_Ngon] = poly2cw(X2_Ngon,Y2_Ngon);
    
    [X_inter,Y_inter] = polybool('intersection',X1_Ngon,Y1_Ngon,X2_Ngon,Y2_Ngon);
    [X_inter, Y_inter] = poly2cw(X_inter,Y_inter);
    S(i) = polyarea(X_inter,Y_inter);
    size_X(i) = length(X1);
    %plot(X_inter,Y_inter);
    fprintf('%d: S:%f X:%f\n',i,S(i),size_X(i));
    
end

plot(X1,Y1,'.b');
hold on;
plot(X1_Ngon,Y1_Ngon,'-b');
%plot(X2,Y2,'.r');
%plot(X2_Ngon, Y2_Ngon,'-r');
hold off;

fprintf('mean(X):%f\n',mean(size_X));

mean_S = mean(S);
var_S = var(S);
under_ = 0;
minimum = S(1);
maximum = S(1);

for i = 1:loopOfExperiments
    if(S(i) < minimum)
        minimum = S(i);
    end
end

for i = 1:loopOfExperiments
    if(S(i) > maximum)
        maximum = S(i);
    end
end


start_ = 0;
end_ = 1;

delta_interval = (end_ - start_)/numOfIntervals;

for i = 1:loopOfExperiments
    for j = 1:numOfIntervals
        if( start_ + (j-1)*delta_interval <= S(i) && S(i) < start_ + (j)*delta_interval)
            intervals(j) = intervals(j) + 1;
        end
    end
end

for i = 1:numOfIntervals
    S_intervals(i) = (start_ + (i-1)*delta_interval); 
end

min_delta_y_of_min = 1;
i = 1;
j = 1;
for i = 1:numOfIntervals
    if(abs(start_ + (i-1)*delta_interval - mean_S) < min_delta_y_of_min)
        min_delta_y_of_min = abs(start_ + (i-1)*delta_interval - mean_S);
        j = i;
    end
end

fprintf('N = %d: \nmean:%f / variance: %f / max: %f / min: %f \n',n,mean_S, var_S, maximum, minimum);

max_estimate = 1;
for i = 1:1:numOfIntervals
    if(intervals(max_estimate) < intervals(i))
        max_estimate = i;
    end
end
X_MAP = S_intervals(max_estimate);
fprintf('Smap = %f\n', X_MAP);
min_delta_y_of_min = intervals(max_estimate);
min_delta_x_of_min = S_intervals(max_estimate);

S_intervals(numOfIntervals+1) = 1;
intervals(numOfIntervals+1) = 0;

gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
exclude = S_intervals < 0.01;
startPoints = [0.0   X_MAP  var_S*100  0.0];
fitobject = fit(S_intervals(:), intervals(:)/loopOfExperiments, gaussEqn, 'Start', startPoints, 'Exclude', exclude);

delta_y_axis = min_delta_y_of_min/(loopOfExperiments*n);
rem_delta = rem(delta_y_axis,n/10000);
delta_y_axis = delta_y_axis - rem_delta;
%fprintf('delta: %f',delta_y_axis);

figure
%plot(S_intervals, (intervals/loopOfExperiments),'-b');
%plot(fitobject , S_intervals , intervals/loopOfExperiments, '-b');
plot(fitobject , S_intervals , intervals/loopOfExperiments, '-b');
title('(N-gon) relation between S & P(S), given N');
temp = 1.2 * intervals(max_estimate)/loopOfExperiments;
axis([0 1 0 temp]);

xlabel('S');
ylabel('P(S)');
ax = gca;
%ax.YTick = 0:delta_y_axis:1;
hold on;
stem(min_delta_x_of_min,min_delta_y_of_min/loopOfExperiments,'-g');

hold off;


