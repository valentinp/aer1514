function normalizedVectors = normalize(vectors)
% PURPOSE:      Normalizes a D x N array of vectors
%                   D := dimension of the vectors
%                   N := number of vectors
%
% INPUT:        vectors - D x N array of vectors
%
% OUTPUT:       normalizedVectors - D x N array of vectors with unit norm
%
% LAST EDIT:    Lee Clement, 2014-03-10

    norm = sqrt(sum(vectors.^2, 1));
    
    normalizedVectors = vectors ./ repmat(norm, [size(vectors,1),1]);
end