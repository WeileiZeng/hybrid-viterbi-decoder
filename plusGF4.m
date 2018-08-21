%addition of two GF4 single-digit number
function z =plusGF4(x,y)
%x,y,z=0,1,2,3. mapped to 0,1,w,W
    if (x>3 | y>3)
        error('number greater than 3 is not allowed for GF(4).')
    end
    if x == y
        z=0;
    else
        z=x+y;
        if z==4
            z=2;
        elseif z==5
            z=1;  
        end
               
    end
    %disp('plus');
    [x,y,z];
end