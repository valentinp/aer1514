function [depth, badDepthMask] = fillMissingDepthWithGroundPlane(context, depth, U, V, m, n, p)
global height; global width;
global maxDepth;
    depth = double(depth);
    xProj = zeros(size(depth));
    yProj = zeros(size(depth));

    badDepthMask = depth == 0;
    
    f = 594.701671;         % px
    cu = 325.334971;        % px
    cv = 233.867764;        % px
    kinectMaxDepth = 3000;  % mm
%     [~,cu] = ind2sub(size(realWorldX), find(realWorldX(~badDepthMask) == 0, 1));
%     [cv,~] = ind2sub(size(realWorldY), find(realWorldY(~badDepthMask) == 0, 1));
%     f = mxNiGetProperty(context, 'ZPD'); % 120 mm
%     pixelSize = mxNiGetProperty(context, 'ZPPS'); % 0.1042 mm
    
    xProj(badDepthMask) = (U(badDepthMask) - cu) / f;
    yProj(badDepthMask) = (height - V(badDepthMask) - cv) / f; % realWorldY and V are in opposite directions
    
    depth(badDepthMask) = p ./ (1 - m*xProj(badDepthMask) - n*yProj(badDepthMask));
    depth(depth > maxDepth | depth < 0) = maxDepth;
    depth(badDepthMask & depth < kinectMaxDepth) = 0;
    depth = uint16(depth);
end
