function newSamples = fetchSamples(context, depth)    
    [x,y] = ginput;
    sampleCount = length(x);
    realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);

    newSamples = zeros(3, sampleCount);
    
    for i = 1:sampleCount
        newSamples(:,i) = reshape(realWorldCoords(round(y(i)), round(x(i)), :), [3,1]);  
    end
    %Convert to m
    newSamples = newSamples/1000;
end

