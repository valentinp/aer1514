function displayLocalization(figHandle,bestRedCentroid, bestBlueCentroid)
%DISPLAYLOCALIZATION Displays localization according to the current
%calibration
hold(figHandle, 'on');
delete(findobj(figHandle, 'type', 'line'));
plot(bestRedCentroid(1), bestRedCentroid(2), 'y*', 'Parent', figHandle);
plot(bestBlueCentroid(1), bestBlueCentroid(2), 'y*','Parent', figHandle);
end

