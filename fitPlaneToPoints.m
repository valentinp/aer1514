function [a,b,c] = fitPlaneToPoints(x,y,z, varargin)
% a + bx + cy = z
% Can also specify successProb and inlierProb for RANSAC

    if nargin == 5
        successProb = varargin{1};
        inlierProb = varargin{2};
    else
        successProb = 0.9999;
        inlierProb = 0.5;
    end

    warning('off','MATLAB:singularMatrix');
    warning('off','MATLAB:nearlySingularMatrix');

    x = x(:);
    y = y(:);
    z = z(:);
    
    % RANSAC
    K = ceil(log(1-successProb) / log(1-inlierProb^3));        % iterations
    N = 3;                                                  % sample size
    thresh = 0.005^2;                                       % inlier error threshold (meters^2)

    maxInliers = 0;
    bestParams = [0,0,0];

    for k = 1:K
        sampleInd = randi(size(x,1),[1,N]);

        % Fit plane
        A(:,3) = y(sampleInd);
        A(:,2) = x(sampleInd);
        A(:,1) = ones(N,1);
        params = A \ z(sampleInd);

        err = z - (params(1) + params(2)*x + params(3)*y);
        err = err .^2;

        numInliers = sum(err < thresh);

        % Keep track of the best solution
        if numInliers > maxInliers
            maxInliers = numInliers;
            bestParams = params;
        end
    end
        
    a = bestParams(1);
    b = bestParams(2);
    c = bestParams(3);
    
    warning('on','MATLAB:singularMatrix');
    warning('on','MATLAB:nearlySingularMatrix');
end