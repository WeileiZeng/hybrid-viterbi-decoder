%Weilei Zeng, 07/12/2018
%return the i th digit of GF4 number x
% x based on 4; i counts from right to left, the rightmost has index 1
%example  pickGF4(1313,3)=3,pickGF4(1314,2)=1
function d = pickGF4(x,i)
    x = base2dec(num2str(x),4);
    x = mod (x,4^i);
    x = x/( 4^(i-1) );
    d = floor(x);
end