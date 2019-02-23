%add two GF4 vectors, either row vector or column vector, or even array. but input a,b should be the same size
%check the size of a and b before using this function, other wise you get the wrong result without error notice

function c =plusGF4vec(a,b)
        [row,col] = size(a);
        c=zeros(row,col);
%        for i =1:max(row,col)
	for i =1:row*col
          c(i)=plusGF4(a(i),b(i));
        end
end
    
