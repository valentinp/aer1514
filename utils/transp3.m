function AT = transp3(A)
% PURPOSE:      Computes the transpose of a M x N x P stack of matrices
%                   M := # rows of the matrices
%                   N := # columns of the matrices
%                   P := # matrices
%
% INPUT:        A - M x N x P stack of matrices
%
% OUTPUT:       AT - N x M x P stack of transposed matrices
%
% LAST EDIT:    Lee Clement, 2014-03-10
    
    AT = zeros([size(A,2), size(A,1), size(A,3)]);
    
    for i = 1:size(A,1)
        AT(:,i,:) = A(i,:,:);
    end

end