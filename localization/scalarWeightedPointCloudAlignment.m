function T_ba = scalarWeightedPointCloudAlignment(pts_a, pts_b)
% Taken from AER 1514 Lecture 15, slide 20
% pts_a and pts_b must be a matrix of column vectors

    weights = ones(size(pts_a,2));
    weights = weights ./ sum(weights);
    weights = repmat(weights, [3,1]);

    centroid_a = sum(weights .* pts_a, 2);
    centroid_b = sum(weights .* pts_b, 2);
    
    for j = size(pts_a,2) : -1: 1
        W(:,:,j) = weights(:,j) .* (pts_a(:,j) - centroid_a)*(pts_b(:,j) - centroid_b)';
    end
    
    W = sum(W,3);
    
    [V,S,U] = svd(W);
    
    R_ba = V * [   1,     0,      0   ; ...
                     0,     1,      0   ; ...
                     0,     0, det(U)*det(V)   ] * U';
                 
    t_ba_a = -R_ba'*centroid_b + centroid_a;
    
    T_ba = [R_ba, -R_ba*t_ba_a;
            0,0,0,1];
end