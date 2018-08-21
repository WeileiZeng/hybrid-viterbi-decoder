% 08/03/2018, maybe outdated, no need for GF(4) code
% Weilei Zeng, 07/25/2018 updated version
% From the generating matrix $G$ for a QCC, and the generating matrix $A$ of
% a  classical CC, construct the generating matrix of the data syndrome code
% in a tripe form, where the syndrome code is defines by $A^T$.
% The formula is in data syndrome code2.pdf

%Input: g (for G), a (for A)
clear
%QCC code
vv=2;gg=[11 12 13];  %111123
%vv=3;gg=[111 121 133];  %111123113


%syndrome code
vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2
%vva=2;gga=[10 11]; %1101
vva=3;gga=[101 111];

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

%H=zeros(va*na+v+extra_length,1+n+na); %1 for only one generator in gga
G=zeros((na+1)*va,n+1+na);


%right bottom corner, indentity matrix
G(end-na+1:end,end-na+1:end)=eye(na);

%first columns in G, using gg
for i =1:v  %row
    for j=1:n  %col
        row=1+(i-1)*(na+1);%)(na+1)*(i-1)+1;
        gij=pickGF4(gg(j),i);%pickGF4 use inverse index
        G(row,j)=gij;
    end
end

%second column in G, suing b
for i = 1:va %row
    for j=1:na  %sub row
        row=(na+1)*(i-1)+1+j;
        G(row,n+1)=pickGF4(gga(j),va-i+1);
    end
end
G(1,n+1)=1

%repeat r=4 times to construct the big code  33 sec decoding time
r=3;
[rowG,colG] = size(G);
rowP=rowG+(na+1)*(r-1);
colP=colG*r+(v-1)*n+na*(va-1);
P=zeros(rowP,colP);

%Add first columns
blockg=zeros(v-1,n*(v-1));
for i = 1:(v-1) %row
    for j=i:(v-1)  %col
        for k = 1:n  % sub col
            blockg(1+(i-1)*(na+1),(j-1)*n+k)=pickGF4(gg(k),v-j+1+i-1);
        end
    end
end
blockg;
P(1:size(blockg,1),1:size(blockg,2))=blockg;

blockI=zeros((1+na)*(va-1),na*(va-1) );
for i =1:(va-1)
    blockI(2+(i-1)*(na+1):2+na-1+(i-1)*(na+1),1+(i-1)*na:na*i)=eye(na);    
end
blockI;
P(1:size(blockI,1),1+size(blockg,2):size(blockg,2)+size(blockI,2))=blockI;

for i = 1:(r) % add G
    row=(na+1)*(i-1)+1;
    col=colG*(i-1)+1+(v-1)*n+na*(va-1);
    P(row:(row+rowG-1),col:(col+colG-1))=G;
end
%P1=P;
%remove last rows
for i =1:(va-1)
  row_to_remove = (na+1)*r+1+(na+1)*(i-1)-(i-1) ;
  P(row_to_remove,:)=[];
end




