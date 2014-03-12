function C = mmult3(A,B)
% PURPOSE:      Performs matrix multiplication over a 
%               M x N x P and N x L x P stack of matrices
%                   L := # columns of matrices B
%                   M := # rows of matrices A
%                   N := # columns of matrices A and # rows of matrices B
%                   P := # matrices
%
% INPUT:        A - M x N x P stack of matrices
%               B - N x L x P stack of matrices
%
% OUTPUT:       C - M x L x P stack of matrices
%
% LAST EDIT:    Lee Clement, 2014-03-10     

    if size(A,2) ~= size(B,1)
        error('Inner matrix dimensions must agree.'); 
        
    elseif size(A,3) ~= size(B,3)
        error('Number of stacked matrices (pages) must agree.');
        
    else    
        C = zeros([size(A,1), size(B,2), size(A,3)]);

        for i = 1:size(A,1)
            for j = 1:size(B,2)
                rows = A(i,:,:);
                cols = B(:,j,:);
                                
                C(i,j,:) = sum( transp3(rows) .* cols , 1);
            end
        end
    end
end