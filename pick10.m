%Weilei Zeng, 07/12/2018

function y = pick10(x,a,b)
%pick digits of x in the range [a,b],a<b
% x,y based on 10 but in GF4
%sample: pick10(19,2,3)=4
% 67--->64+3--->103 (GF4)---> 10 (GF4) ----> 4
    y=mod(x,4^(b));  %remove the part big than b (left hand side of b digit)
    y=floor( y/(4^(a-1)) ); % remove the part smaller than a, (right hand side of a digit)
end