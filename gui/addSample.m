function addSample(depth)
    global samplesList;
    global samplesTable;
    [x,y] = ginput;
    sampleCount = length(x);
    depthList = zeros(sampleCount, 1);
    for i = 1:sampleCount
        depthList(i) = depth(round(y(i)), round(x(i)));  
    end
    disp([round(x)';round(y)'; depthList'])
    samplesList(1:3,end+1:(end+sampleCount)) = [round(x)';round(y)'; depthList'];
    set(samplesTable, 'Data', samplesList);
end

