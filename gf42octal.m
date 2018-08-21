%convert a decimal matrix into an octal matrix
%Input: matrix with element based on 10, but represent GF4
%process: map element to its weight: [0 1 w W] --> [0 1 1 1] and write it
%in octal format
%Output: an octal matrix
function B = gf42octal(A)
    [x,y]=size(A);
    B=zeros(x,y);
    for i =1:x
        for j = 1:y         
            B(i,j)= weightofGF4(A(i,j));
        end
    end
end

function w = weightofGF4(x)
%example: x (decimal) -->1303 (GF4) -->1101 (F2) -->15  (octal)
    str = dec2base(x,4);
    for i = 1:size(str,2)
        switch str(i)
            case '0'
                %pass
            otherwise
                str(i) = '1';
        end
    end
    w=str2num(dec2base(bin2dec(str),8));
end
