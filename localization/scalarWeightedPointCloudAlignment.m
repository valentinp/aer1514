function [rotMat, transVec] = scalarWeightedPointCloudAlignment(oldPts, newPts, weights)

    weights = weights ./ sum(weights);
    weights = repmat(weights, [3,1]);

    oldCentroid = sum(weights .* oldPts, 2);
    newCentroid = sum(weights .* newPts, 2);
    
    for j = size(oldPts,2) : -1: 1
        W(:,:,j) = weights(:,j) .* (oldPts(:,j) - oldCentroid)*(newPts(:,j) - newCentroid)';
    end
    
    W = sum(W,3);
    
    [V,S,U] = svd(W);
    
    rotMat = V * [   1,     0,      0   ; ...
                     0,     1,      0   ; ...
                     0,     0, det(U)*det(V)   ] * U';
                 
    transVec = -rotMat'*newCentroid + oldCentroid;
    
end