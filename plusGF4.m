%Weilei Zeng Jan 2018
%addition of two GF4 single-digit number
% The input x, y should be single number as 0,1,2,3. However, An error will not be throw if x or y is an array. I didn,t check here to save time, but it should be kept in mind to avoid uncatchable error when using this function.

function z =plusGF4(x,y)
%x,y,z=0,1,2,3. mapped to 0,1,w,W
    if (x>3 | y>3)
        % it will save 40% of time if this check could be removed
        error('plusGF4.m: number greater than 3 is not allowed for GF(4).')
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
end