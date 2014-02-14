function C = mmult3(A,B)
% Performs batch multiplication of stacked matrices      

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