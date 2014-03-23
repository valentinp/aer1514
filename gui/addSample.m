function addSample(context, depth, handles)    
    [x,y] = ginput;
    sampleCount = length(x);
    realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);

    newSamples = zeros(3, sampleCount);
    
    for i = 1:sampleCount
        newSamples(:,i) = reshape(realWorldCoords(round(y(i)), round(x(i)), :), [3,1]);  
    end
    newSamples = newSamples/1000;
    
    %Convert to m
    handles.samplesList(1:3,end+1:(end+sampleCount)) = newSamples;
    set(handles.table_samples, 'Data', handles.samplesList);
end

