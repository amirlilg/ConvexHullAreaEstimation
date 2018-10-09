
loopOfExperiments = 1000;
numOfIntervals = 200;

S = double(loopOfExperiments);

n = 0;
prompt = 'ENTER N:';
n = input(prompt);
while(n == 1 || n == 0 || n == 2)
    fprintf('wrong input! try again!\n');
    n = input(prompt);
end
for i = 1:loopOfExperiments
    
    %randomize 2 set of 2-D dots & determining convexHull
    X1 = rand([1,n]);
    Y1 = rand([1,n]);
    X2 = rand([1,n]);
    Y2 = rand([1,n]);
    K1 = convhull(X1,Y1);
    K2 = convhull(X2,Y2);
    X1_convHull = X1(K1);
    X2_convHull = X2(K2);
    Y1_convHull = Y1(K1);
    Y2_convHull = Y2(K2);
    
    %calculating overlap
    [X1_convHull, Y1_convHull] = poly2cw(X1_convHull,Y1_convHull);
    [X2_convHull, Y2_convHull] = poly2cw(X2_convHull,Y2_convHull);
    
    [X_inter,Y_inter] = polybool('intersection',X1_convHull,Y1_convHull,X2_convHull,Y2_convHull);
    [X_inter, Y_inter] = poly2cw(X_inter,Y_inter);
    S(i) = polyarea(X_inter,Y_inter);
    
    fprintf('S(%d):%f\n',i,S(i));
    %
    
end
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


if(n >= 1000)
    numOfIntervals = 8 * numOfIntervals;    
else
    if(n >= 200)
    numOfIntervals = 2 * numOfIntervals;
    end
end


intervals = double(numOfIntervals);
for i= 1:1:numOfIntervals
    intervals(i) = 0;
end


S_intervals = double(numOfIntervals);



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
fprintf('delta: %f',delta_y_axis);

figure
%plot(S_intervals, (intervals/loopOfExperiments),'-b');
%plot(fitobject , S_intervals , intervals/loopOfExperiments, '-b');
plot(fitobject , S_intervals , intervals/loopOfExperiments, '-b');
%histogram(S_intervals , intervals/loopOfExperiments)
title('(N-hull) relation between S & P(S), given N');
temp = 1.2 * intervals(max_estimate)/loopOfExperiments;
axis([0 1 0 temp]);


if(n == 3)
    axis([0 0.2 0 temp]);
end
if(n >= 200)
    numOfIntervals = 4 * numOfIntervals;
    axis([0.8 1.0 0 temp]);
end
if(n >= 1000)
    numOfIntervals = 8 * numOfIntervals;
    axis([0.95 1.0 0 temp]);
end

xlabel('S');
ylabel('P(S)');
ax = gca;
%ax.YTick = 0:delta_y_axis:1;
hold on;
stem(min_delta_x_of_min,min_delta_y_of_min/loopOfExperiments,'-g');

hold off;

for i = 1:length(S_intervals)
fprintf('%f %f\n', S_intervals(i),intervals(i)/loopOfExperiments);
end
%{
for i = 1:numOfIntervals
    fprintf('interval(%f):%f\n',i,intervals(i)); 
end
%}
%fprintf('sum interval:%f\n',sum(intervals));


