
loopOfExperiments = 1000;
numOfIntervals = 30;
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
    %
    
    %printing convnxHull(x,y)
    %{
    fprintf('X1 & Y1 (%d):\n',size(X1_convHull));
    temp_size = size(X1_convHull);
    for j = 1:1:temp_size
        fprintf('(%f,%f)\n', X1_convHull(j),Y1_convHull(j));
    end
    
    temp_size = size(X2_convHull);
    fprintf('X2 & Y2 (%d):\n',size(X2_convHull));
    for k = 1:1:size(X2_convHull)
        fprintf('(%f,%f)\n', X2_convHull(k),Y2_convHull(k));
    end
    %}
    
    %
    
    %draw a figure representing 2 convexHull
    
    %figure
    %{
    
        plot(X1_convHull,Y1_convHull);
        title('2 Polygons & Overlap');
        xlabel('x');
        ylabel('y');
        hold on;
        %%plot(X1,Y1,'.b');
        plot(X2_convHull,Y2_convHull);
    %}
    
    %calculating overlap
    [X1_convHull, Y1_convHull] = poly2cw(X1_convHull,Y1_convHull);
    [X2_convHull, Y2_convHull] = poly2cw(X2_convHull,Y2_convHull);
    if(~(size(polybool('intersection',X1_convHull,Y1_convHull,X2_convHull,Y2_convHull)) == 0))
        S(i) = max(polybool('intersection',X1_convHull,Y1_convHull,X2_convHull,Y2_convHull));
    else
        S(i) = 0;
    end
    fprintf('S(%d):%f\n',i,S(i));
    %
    
end
mean_S = mean(S);
var_S = var(S);
under_ = 0;
minimum = S(1);
maximum = S(1);
%{
for i = 1:loopOfExperiments
    if(S(i) < 0.9)
        under_ = under_ + 1;
    end
end
%}

%fprintf('under_:%f\n',under_);

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
fprintf('Xmap = %f\n', X_MAP);
min_delta_y_of_min = intervals(j);
min_delta_x_of_min = S_intervals(j);

plot(S_intervals, intervals/loopOfExperiments,'-b');
title('relation between S & Frequency(S), given N');
xlabel('S');
ylabel('P(S)');
ax = gca;
ax.XTick = 0:0.05:1;
ax.YTick = 0:0.1:1;
hold on;
stem(min_delta_x_of_min,min_delta_y_of_min/loopOfExperiments,'.r');
hold off;

%{
for i = 1:numOfIntervals
    fprintf('interval(%f):%f\n',i,intervals(i)); 
end
%}
%fprintf('sum interval:%f\n',sum(intervals));


