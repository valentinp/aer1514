function AT = transp3(A)
% Performs batch transposition of stacked matrices
    
    AT = zeros([size(A,2), size(A,1), size(A,3)]);
    
    for i = 1:size(A,1)
        AT(:,i,:) = A(i,:,:);
    end

end