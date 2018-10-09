%phase 1 -  n-gon overlapping area
loopOfExperiments = 1000;
numOfIntervals = 75;
intervals = double(loopOfExperiments);
for i= 1:1:numOfIntervals
    intervals(i) = 0;
end
S_intervals = double(numOfIntervals);

S = double(loopOfExperiments);
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
    %plot(X_inter,Y_inter);
    fprintf('S(%d):%f\n',i,S(i));
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

is = double(5);


fprintf('\n MAX_ESTIMATE: %d\n',max_estimate);

i = 1;
j = length(intervals);

while(intervals(i) == 0)
    i = i+1;
end
while(intervals(j) == 0)
    j = j -1;
end


is(1) = i;
is(2) = fix( (max_estimate + i)/2 );
is(3) = max_estimate;
is(4) = fix( (max_estimate + j)/2 );
is(5) = j;




if(max_estimate == 1)
    is(1) = 1;
    i = 1;
    while(intervals(i) ~= 0)
        i = i+1;
    end
    is(2) = fix(i/4);
    is(3) = fix(i/2);
    is(4) = fix(3*i/4); 
    is(5) = i;
    
end
if( 1 < max_estimate && max_estimate < 7 )
    i = max_estimate;
    while(intervals(i) ~= 0)
        i = i+1;
    end
    is(1) = 1;
    is(2) = max_estimate;
    is(3) = fix((2*max_estimate + i)/3);
    is(4) = fix((max_estimate + 2*i)/3);
    is(5) = i;
end

if( length(intervals) - 4 < max_estimate)
    while(S_intervals == 0)
        i = i+1;
    end
    is(1) = i;
    is(2) = fix(( max_estimate + i*2 )/3);
    is(3) = fix(( max_estimate*2 + i)/3);
    is(4) = max_estimate;
    is(5) = length(intervals);
end

X_sample = S_intervals(is);
Y_sample = intervals(is);

zarayeb = polyfit(X_sample,Y_sample,2);

a1 = min(X_sample);
a2 = max(X_sample);

X_fit = linspace(a1 , a2);
Y_fit = polyval(zarayeb, X_fit);
key = 0;


a3 = min(Y_fit) - ( max(Y_fit) - min(Y_fit) )/6;
a4 = max(Y_fit) + ( max(Y_fit) - min(Y_fit) )/6;


max_YS = max(Y_sample);
min_YS = min(Y_sample);
max_YF = max(Y_fit);
min_YF = min(Y_fit);

figure
plot(X_sample,Y_sample/loopOfExperiments,'*b');
axis([a1 a2 min(min_YF,min_YS)/loopOfExperiments max(max_YF,max_YS)/loopOfExperiments]);
hold on;
plot(X_fit,Y_fit/loopOfExperiments,'-r');
hold off;



fprintf('min: %f & max: %f',min(Y_fit),max(Y_fit));







