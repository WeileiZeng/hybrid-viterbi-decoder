%convert a decimal matrix into an octal matrix
function B = dec2octal(A)
    [x,y]=size(A);
    for i =1:x
        for j = 1:y         
            B(i,j)= str2num(dec2base( A(i,j),6 ));
        end
    end
end