%simplectic product of two GF4 single-digit number
%this is much fast than using GF(4) defined by matlab gf(x,m)
function z =timesGF4(x,y)
%x,y,z=0,1,2,3. mapped to 0,1,w,W
%multiply x y without conjugate
%for simplectic product with conjugate, use simplecticGF4(x,y)
    if (x>3 | y>3)
        error('number greater than 3 is not allowed for GF(4).')
    end
    switch x
        case 0
            z=0;
        case 1
            z=y;
        case 2
            
            switch y
                case 0
                    z=0;
                case 1
                    z=2;
                case 2
                    z=3;
                case 3
                    z=1;
            end
        case 3
            switch y
                case 0
                    z=0;
                case 1
                    z=3;
                case 2
                    z=1;
                case 3
                    z=2;
            end
    end
end