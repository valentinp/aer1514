function addSample(context, depth)
    global samplesList;
    global samplesTable;
    
    [x,y] = ginput;
    sampleCount = length(x);
    depthList = zeros(sampleCount, 1);
    for i = 1:sampleCount
        depthList(i) = depth(round(y(i)), round(x(i)));  
    end
    
    disp([round(x)';round(y)'; depthList']);
    
    %Create newSamples array
    newSamples = zeros(sampleCount, 1, 3);
    newSamples(:,1,1) = round(x);
    newSamples(:,1,2) = round(y);
    newSamples(:,1,3) = depthList;
    
    newSamplesRealWorld = mxNiConvertProjectiveToRealWorld(context, newSamples);

    samplesList(1:3,end+1:(end+sampleCount)) = [newSamplesRealWorld(:,1,1)';newSamplesRealWorld(:,1,2)''; newSamplesRealWorld(:,1,3)'];
    set(samplesTable, 'Data', samplesList);
end

