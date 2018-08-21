%add two GF4 vectors, either row vector or column vector
function c =plusGF4vec(a,b)
        [row,col] = size(a);
        c=zeros(row,col);
        for i =1:max(row,col)
            c(i)=plusGF4(a(i),b(i));
        end
end
    