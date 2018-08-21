%simplectic product of two GF4 single-digit number
function z =symplecticGF4(x,y)
%x,y,z=0,1,2,3. mapped to 0,1,w,W
%take congugate of x, and then multiply them
    
    X=x; %capital denote conjugate
    switch x
        case 2
            X=3;
        case 3
            X=2;
    end
    z=timesGF4(X,y);
    [x,y,z];
end