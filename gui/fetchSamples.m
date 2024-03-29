function newSamples = fetchSamples(context, rgb, depth)    
global height; global width;

    f = figure;
    imgHandle = imshow(zeros(height,width,3,'uint8'));
    hold on;
    displayKinectRGB(rgb,imgHandle); 
    
    [x,y] = ginput;
    sampleCount = length(x);
    realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);
    newSamples = zeros(3, sampleCount);
    
    for i = 1:sampleCount
        newSamples(:,i) = reshape(realWorldCoords(round(y(i)), round(x(i)), :), [3,1]);  
%         newSamples(1,i) = -newSamples(1,i);
    end
    %Convert to m
    newSamples = newSamples/1000;
    
    close(f);
end