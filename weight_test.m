

v=[1 1 0 1 1 1 1 1];
v+v
mat=zeros(20,30);
mat(1,1:8)=v;
mat(2,3:10)=v;
mat(2,3:10)
mat(1:2,1:10)

weight(mat(2,3:10))
v1=mat(1,1:10);
v2=mat(2,1:10);
v3=bitxor(v1,v2)
weight(v3)


function w = weight(vv)
%return weight of a binary vector
    w=0;
    for i=vv
        w=w+i; 
    end   
end
