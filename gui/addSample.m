function addSample(context, depth)
    global samplesList;
    global samplesTable;
    
    [x,y] = ginput;
    sampleCount = length(x);
    realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);

    newSamples = zeros(3, sampleCount);
    
    for i = 1:sampleCount
        newSamples(:,i) = reshape(realWorldCoords(round(y(i)), round(x(i)), :), [3,1]);  
    end
    newSamples = newSamples/1000;
    
    %Convert to m
    samplesList(1:3,end+1:(end+sampleCount)) = newSamples;
    set(samplesTable, 'Data', samplesList);
end

