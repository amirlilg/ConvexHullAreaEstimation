loopOfExperiments = 1000;
numOfIntervals = 50;
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

tetta = pi/3;
X_MAX = 3/2;
Y_MAX = sqrt(3)/2;

for i = 1:loopOfExperiments
    
    X1 = rand([1,n]);
    Y1 = rand([1,n]);
    X2 = rand([1,n]);
    Y2 = rand([1,n]);
    
    X1_real = X1 + Y1 * cos(tetta);
    X2_real = X2 + Y2 * cos(tetta);
    Y1_real = Y1 * sin(tetta);
    Y2_real = Y2 * sin(tetta);
    
    zarib_of_X = sqrt(3);
    zarib_of_Y = 1;
    C = -sqrt(3);
    
    for j = 1:n
        if(areOnSameSide(X1_real(j),Y1_real(j),0,0,zarib_of_X,zarib_of_Y,C) == 0)
            X1_real(j) = X_MAX - X1_real(j);
            Y1_real(j) = Y_MAX - Y1_real(j);
        end
        if(areOnSameSide(X2_real(j),Y2_real(j),0,0,zarib_of_X,zarib_of_Y,C) == 0)
            X2_real(j) = X_MAX - X2_real(j);
            Y2_real(j) = Y_MAX - Y2_real(j);
        end
    end
    
    
    X1_convHull = X1_real(convhull(X1_real,Y1_real));
    Y1_convHull = Y1_real(convhull(X1_real,Y1_real));
    X2_convHull = X2_real(convhull(X2_real,Y2_real));
    Y2_convHull = Y2_real(convhull(X2_real,Y2_real));
    
   
    %calculating overlap
    [X1_convHull, Y1_convHull] = poly2cw(X1_convHull,Y1_convHull);
    [X2_convHull, Y2_convHull] = poly2cw(X2_convHull,Y2_convHull);
    [X_inter,Y_inter] = polybool('intersection',X1_convHull,Y1_convHull,X2_convHull,Y2_convHull);
    [X_inter, Y_inter] = poly2cw(X_inter,Y_inter);
    S(i) = polyarea(X_inter,Y_inter);
    
    fprintf('S(%d):%f\n',i,S(i));
    %
end

plot(X1_real,Y1_real,'.b');
hold on;
plot(X2_real,Y2_real,'.r');
plot(X1_convHull, Y1_convHull);
plot(X2_convHull, Y2_convHull);
plot([0,1,0.5,0],[0 0 Y_MAX,0],'-k')
hold off;


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
end_ = sqrt(3)/4;

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

S_intervals(numOfIntervals+1) = sqrt(3)/4;
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
title('(N-gon Triangle) relation between S & P(S), given N');
temp = 1.2 * intervals(max_estimate)/loopOfExperiments;
axis([0 end_ 0 temp]);

xlabel('S');
ylabel('P(S)');
ax = gca;
%ax.YTick = 0:delta_y_axis:1;
hold on;
stem(min_delta_x_of_min,min_delta_y_of_min/loopOfExperiments,'-g');

hold off;
