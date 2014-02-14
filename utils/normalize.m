function normalizedVectors = normalize(vectors)
% Assumes vectors in column format

    norm = sqrt(sum(vectors.^2, 1));
    
    normalizedVectors = vectors ./ repmat(norm, [size(vectors,1),1]);
end