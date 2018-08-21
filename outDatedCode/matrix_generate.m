% Weilei Zeng, 07/11/2018 outdated, don't use
% From the generating matrix $G$ for a QCC, and the generating matrix $A$ of
% a  classical CC, construct the generating matrix of the data syndrome code
% in a tripe form, where the syndrome code is defines by $A^T$.
% The formula is in data syndrome code2.pdf

%Input: g (for G), a (for A)

%QCC code
vv=2;gg=[11 12 13];  %111123

%syndrome code
vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2
%vva=2;gga=[10 11]; %1101
% vva=3;gga=[101 111];

v=vv;  %constraint length
n=size(gg,2);  %block length
va=vva;  %constraint length  u
na=size(gga,2);  %block length s


%construct small H for trellis
if va>n  % add extra zero rows if u and v doesn't match
    extra_length = va-n;
else
    extra_length=na*(v-va);
end

H=zeros(va*na+v+extra_length,1+n+na); %1 for only one generator in gga

%define in the inverse way and flip in the end by flip(fliplr(H))
%right bottom corner
H(2:na+1,1:na)=eye(na);

%second columns in G
for i =1:v
    for j=1:n
        row=(na+1)*(i-1)+1;
        gji=pickGF4(gg(j),v-i+1);%pickGF4 use inverse index
        H(row,na+n-j+1)=gji;
    end
end


%first column in G
for i = 1:va
    for j=1:na
        %row=(s+1)*(i-1)+j;
        row=(na+1)*(va-i+1)-j+1;
        H(row,na+n+1)=pickGF4(gga(j),va-i+1);
    end
end

%H(na+1+na+1,na+n+1)=1;

H(v*(na+1)-na,end)=1;
G=flip(fliplr(H))

%repeat r=4 times to construct the big code  33 sec decoding time
r=5;
[rowG,colG] = size(G);
P=zeros(rowG+(na+1)*(r+v-1),colG*(r+v-1));
for i = 1:(r+v-1)
    row=(na+1)*(i-1)+1;
    col=colG*(i-1)+1;
    P(row:(row+rowG-1),col:(col+colG-1))=G;
end
P1=P;
P(1:rowG-1-na,:)=[];%remove first rows
for i =1:(va-1) %remove first cols of b
   P(:,1+colG*(i-1)-(i-1))=[]; 
   temp=(na+1)*r+1+(i-1)*na-(i-1)
   P(temp,:)=[];
end




