function depth = fillMissingDepthWithGroundPlane(context, depth, U, V, m, n, p)
global height; global width;
global maxDepth;

%     realWorldCoords = mxNiConvertProjectiveToRealWorld(context, depth);
%     realWorldX = realWorldCoords(:,:,1);
%     realWorldY = realWorldCoords(:,:,2);
    % NB: realWorldCoords(:,:,3) is just the original depth image
    depth = double(depth);
    xProj = zeros(size(depth));
    yProj = zeros(size(depth));

    badDepthMask = depth == 0;
    
    f = 575.8; % px
    cu = 314.5;
    cv = 235.5;
%     [~,cu] = ind2sub(size(realWorldX), find(realWorldX(~badDepthMask) == 0, 1));
%     [cv,~] = ind2sub(size(realWorldY), find(realWorldY(~badDepthMask) == 0, 1));
%     f = mxNiGetProperty(context, 'ZPD'); % 120 mm
%     pixelSize = mxNiGetProperty(context, 'ZPPS'); % 0.1042 mm
    
    xProj(badDepthMask) = (U(badDepthMask) - cu) / f;
    yProj(badDepthMask) = (height - V(badDepthMask) - cv) / f; % realWorldY and V are in opposite directions
    
    depth(badDepthMask) = p ./ (1 - m*xProj(badDepthMask) - n*yProj(badDepthMask));
    depth(badDepthMask & depth < 3000) = 0;
    depth(depth > maxDepth | depth < 0) = maxDepth;
    depth = uint16(depth);
end